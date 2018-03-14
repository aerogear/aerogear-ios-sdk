import Alamofire
import Foundation

@objc public protocol AgsHttpRequestProtocol {
    func get(_ url: String, params: [String: AnyObject]?, headers: [String: String]?, _ handler: @escaping (Any?, Error?) -> Void)

    func post(_ url: String, body: [String: Any]?, headers: [String: String]?, _ handler: @escaping (Any?, Error?) -> Void)

    func put(_ url: String, body: [String: Any]?, headers: [String: String]?, _ handler: @escaping (Any?, Error?) -> Void)

    func delete(_ url: String, headers: [String: String]?, _ handler: @escaping (Any?, Error?) -> Void)
}

/**
 This is a implementation of HttpRequest based on AlamoFire
 Implementation is designed to work with Json payload
 */
@objc public class AgsHttpRequest: NSObject, AgsHttpRequestProtocol {

    public func get(_ url: String, params: [String: AnyObject]? = [:], headers: [String: String]? = [:],
                    _ handler: @escaping (Any?, Error?) -> Void) {
        Alamofire.request(url, parameters: params, headers: headers).responseJSON { (responseObject) -> Void in
            self.handleResponse(responseObject, handler)
        }
    }

    public func post(_ url: String, body: [String: Any]? = [:], headers: [String: String]? = [:], _ handler: @escaping (Any?, Error?) -> Void) {
        Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            self.handleResponse(responseObject, handler)
        }
    }

    public func put(_ url: String, body: [String: Any]? = [:], headers: [String: String]? = [:], _ handler: @escaping (Any?, Error?) -> Void) {
        Alamofire.request(url, method: .put, parameters: body, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            self.handleResponse(responseObject, handler)
        }
    }

    public func delete(_ url: String, headers: [String: String]? = [:], _ handler: @escaping (Any?, Error?) -> Void) {
        Alamofire.request(url, method: .delete, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            self.handleResponse(responseObject, handler)
        }
    }

    private func handleResponse(_ response: DataResponse<Any>, _ handler: @escaping (Any?, Error?) -> Void) {
        guard case let .failure(error) = response.result else {
            handler(response.result.value, nil)
            return
        }

        if let error = error as? AFError {
            switch error {
            case .responseSerializationFailed(let reason):
                if case .inputDataNilOrZeroLength = reason {
                    // Return success if empty
                    handler(nil, nil)
                    return
                }
                handler(nil, error)
                break
            default:
                handler(nil, error)
                return
            }
        }
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
