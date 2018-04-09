import Alamofire
import Foundation

/**
Protocol used to make network requests by exposing standard REST methods.
*/
public protocol AgsHttpRequestProtocol {
    func get(_ url: String, params: [String: AnyObject]?, headers: [String: String]?, _ handler: @escaping (AgsHttpResponse) -> Void)

    func post(_ url: String, body: [String: Any]?, headers: [String: String]?, _ handler: @escaping (AgsHttpResponse) -> Void)

    func put(_ url: String, body: [String: Any]?, headers: [String: String]?, _ handler: @escaping (AgsHttpResponse) -> Void)

    func delete(_ url: String, headers: [String: String]?, _ handler: @escaping (AgsHttpResponse) -> Void)
}

/**
 This is a implementation of HttpRequest based on AlamoFire
 Implementation is designed to work with Json payload
 */
public class AgsHttpRequest: NSObject, AgsHttpRequestProtocol {
    public func get(_ url: String, params: [String: AnyObject]? = [:], headers: [String: String]? = [:],
                    _ handler: @escaping (AgsHttpResponse) -> Void) {
        Alamofire.request(url, parameters: params, headers: headers).responseJSON { (responseObject) -> Void in
            self.handleResponse(responseObject, handler)
        }
    }

    public func post(_ url: String, body: [String: Any]? = [:], headers: [String: String]? = [:], _ handler: @escaping (AgsHttpResponse) -> Void) {
        Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            self.handleResponse(responseObject, handler)
        }
    }

    public func put(_ url: String, body: [String: Any]? = [:], headers: [String: String]? = [:], _ handler: @escaping (AgsHttpResponse) -> Void) {
        Alamofire.request(url, method: .put, parameters: body, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            self.handleResponse(responseObject, handler)
        }
    }

    public func delete(_ url: String, headers: [String: String]? = [:], _ handler: @escaping (AgsHttpResponse) -> Void) {
        Alamofire.request(url, method: .delete, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            self.handleResponse(responseObject, handler)
        }
    }

    private func handleResponse(_ response: DataResponse<Any>, _ handler: @escaping (AgsHttpResponse) -> Void) {
        let statusCode = response.response?.statusCode

        guard case let .failure(error) = response.result else {
            handler(AgsHttpResponse(response: response.result.value, statusCode: statusCode))
            return
        }

        if let error = error as? AFError {
            switch error {
            case let .responseSerializationFailed(reason):
                if case .inputDataNilOrZeroLength = reason {
                    // Return success if empty
                    handler(AgsHttpResponse(response: [], statusCode: statusCode))
                    return
                }
            default:
                break
            }
        }
        handler(AgsHttpResponse(error: error, statusCode: statusCode))
    }
}

/**
 Extending encodable in order to support Encodable => Dictionary conversion
 */
public extension Encodable {
    /**
     Encodable => Dictionary conversion
     */
    public func adaptToDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
}

/**
 Extension allows to debug requests that are made to the Push server
*/
extension Request {
    public func debugLog() -> Self {
        #if DEBUG
            debugPrint(self)
        #endif
        return self
    }
}
