import AGSCore
import Apollo
import Foundation

extension HTTPURLResponse {
    var isSuccessful: Bool {
        return (200 ..< 300).contains(statusCode)
    }

    var statusCodeDescription: String {
        return HTTPURLResponse.localizedString(forStatusCode: statusCode)
    }

    var textEncoding: String.Encoding? {
        guard let encodingName = textEncodingName else { return nil }

        return String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringConvertIANACharSetNameToEncoding(encodingName as CFString)))
    }
}

/// A transport-level, HTTP-specific error.
public struct SyncHTTPResponseError: Error, LocalizedError {
    public enum ErrorKind {
        case errorResponse
        case invalidResponse

        var description: String {
            switch self {
            case .errorResponse:
                return "Received error response"
            case .invalidResponse:
                return "Received invalid response"
            }
        }
    }

    /// The body of the response.
    public let body: Data?
    /// Information about the response as provided by the server.
    public let response: HTTPURLResponse
    public let kind: ErrorKind

    public var bodyDescription: String {
        if let body = body {
            if let description = String(data: body, encoding: response.textEncoding ?? .utf8) {
                return description
            } else {
                return "Unreadable response body"
            }
        } else {
            return "Empty response body"
        }
    }

    public var errorDescription: String? {
        return "\(kind.description) (\(response.statusCode) \(response.statusCodeDescription)): \(bodyDescription)"
    }
}

// Note this is added here due to limitation in SDK
// It cannot use mobile core networking due to different interface.
// Main request object require request that should be cancellable.
/// A network transport that uses HTTP POST requests to send GraphQL operations to a server, and that uses `URLSession` as the networking implementation.
public class SyncNetworkTransport: NetworkTransport {
    let url: URL
    let session: URLSession
    let serializationFormat = JSONSerializationFormat.self
    public var headerProvider: HeaderProvider?

    /// Creates a network transport with the specified server URL and session configuration.
    ///
    /// - Parameters:
    ///   - url: The URL of a GraphQL server to connect to.
    ///   - configuration: A session configuration used to configure the session. Defaults to `URLSessionConfiguration.default`.
    ///   - sendOperationIdentifiers: Whether to send operation identifiers rather than full operation text, for use with servers that support query persistence. Defaults to false.
    public init(url: URL, configuration: URLSessionConfiguration = URLSessionConfiguration.default, sendOperationIdentifiers: Bool = false) {
        self.url = url
        self.session = URLSession(configuration: configuration)
        self.sendOperationIdentifiers = sendOperationIdentifiers
    }

    private func getHeaders() -> Promise<[String:String]> {
        
        let promise = Promise<[String:String]> { (fullfill, error) in
            headerProvider?.getHeaders(completionHandler: { headers in
                fullfill(headers)
            })
        }
        
        return promise;
    }

    /// Send a GraphQL operation to a server and return a response.
    ///
    /// - Parameters:
    ///   - operation: The operation to send.
    ///   - completionHandler: A closure to call when a request completes.
    ///   - response: The response received from the server, or `nil` if an error occurred.
    ///   - error: An error that indicates why a request failed, or `nil` if the request was succesful.
    /// - Returns: An object that can be used to cancel an in progress request.
    public func send<Operation>(operation: Operation, completionHandler: @escaping (_ response: GraphQLResponse<Operation>?, _ error: Error?) -> Void) -> Cancellable {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // The send method returns a `Cancellable`, but since we need to get the headers asynchronously (the access token must be refreshed to always be actual),
        // we won't have a task to return until the token is successfully or unsuccessfully refreshed.
        // We use this `CancellableFuture` to be able to return a `Cancellable` object that is eventually populated with the correct, cancellable task.
        let cancellable = CancellableFuture()
        
        getHeaders().andThen { (headers) in
            for headerKey in headers.keys {
                request.setValue(headers[headerKey], forHTTPHeaderField: headerKey)
            }
            
            let body = self.requestBody(for: operation)
            request.httpBody = try! self.serializationFormat.serialize(value: body)
            let task = self.session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
                if let error = error {
                    completionHandler(nil, error)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    fatalError("Response should be an HTTPURLResponse")
                }
                
                if !httpResponse.isSuccessful {
                    completionHandler(nil, SyncHTTPResponseError(body: data, response: httpResponse, kind: .errorResponse))
                    return
                }
                
                guard let data = data else {
                    completionHandler(nil, SyncHTTPResponseError(body: nil, response: httpResponse, kind: .invalidResponse))
                    return
                }
                
                do {
                    guard let body = try self.serializationFormat.deserialize(data: data) as? JSONObject else {
                        throw SyncHTTPResponseError(body: data, response: httpResponse, kind: .invalidResponse)
                    }
                    let response = GraphQLResponse(operation: operation, body: body)
                    completionHandler(response, nil)
                } catch {
                    completionHandler(nil, error)
                }
            }
            cancellable.setTask(task)
        }

        cancellable.getTask().andThen { (task) in
            task.resume()
        }
        
        return cancellable
    }

    private let sendOperationIdentifiers: Bool

    private func requestBody<Operation: GraphQLOperation>(for operation: Operation) -> GraphQLMap {
        if sendOperationIdentifiers {
            guard let operationIdentifier = operation.operationIdentifier else {
                preconditionFailure("To send operation identifiers, Apollo types must be generated with operationIdentifiers")
            }
            return ["id": operationIdentifier, "variables": operation.variables]
        }
        return ["query": operation.queryDocument, "variables": operation.variables]
    }
}

/// An object that implement `Cancellable` but is populated with the real `Cancellable` object in a future time.
private class CancellableFuture : Cancellable {
    
    private var task: URLSessionTask?
    private var fullfill:((URLSessionTask) -> Void)?
    
    func getTask() -> Promise<URLSessionTask> {
        if (task != nil) {
            return Promise<URLSessionTask>(fulfilled: task!)
        }
        
        return Promise<URLSessionTask> { (fullfill, reject) in
            self.fullfill = fullfill
        }
    }
    
    func setTask(_ task: URLSessionTask) {
        self.task = task
        fullfill?(task)
    }
    
    func cancel() {
        getTask().andThen { (task) in
            task.cancel()
        }
    }
}
