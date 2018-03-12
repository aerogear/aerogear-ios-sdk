import Alamofire
import Foundation

public protocol AgsHttpRequestProtocol {
    func get(_ url: String, params: [String: AnyObject]?, headers: [String: String]?, _ handler: @escaping (Any?, Error?) -> Void)

    func post(_ url: String, body: [String: Any]?, headers: [String: String]?, _ handler: @escaping (Any?, Error?) -> Void)

    func put(_ url: String, body: [String: Any]?, headers: [String: String]?, _ handler: @escaping (Any?, Error?) -> Void)

    func delete(_ url: String, headers: [String: String]?, _ handler: @escaping (Any?, Error?) -> Void)
}

/**
 This is a implementation of HttpRequest based on AlamoFire
 Implementation is designed to work with Json payload
 */
public class AgsHttpRequest: AgsHttpRequestProtocol {

    public func get(_ url: String, params: [String: AnyObject]? = [:], headers: [String: String]? = [:],
                    _ handler: @escaping (Any?, Error?) -> Void) {
        Alamofire.request(url, parameters: params, headers: headers).responseJSON { (responseObject) -> Void in
            if self.isHTTPResponseSuccess(responseObject)  {
                handler(responseObject.result.value, nil)
                return
            }
            if responseObject.result.isFailure {
                handler(nil, responseObject.result.error)
                return
            }
        }
    }

    public func post(_ url: String, body: [String: Any]? = [:], headers: [String: String]? = [:], _ handler: @escaping (Any?, Error?) -> Void) {
        Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            if self.isHTTPResponseSuccess(responseObject) {
                handler(responseObject.result.value, nil)
                return
            }
            if responseObject.result.isFailure {
                handler(nil, responseObject.result.error)
                return
            }
        }
    }

    public func put(_ url: String, body: [String: Any]? = [:], headers: [String: String]? = [:], _ handler: @escaping (Any?, Error?) -> Void) {
        Alamofire.request(url, method: .put, parameters: body, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in

            if self.isHTTPResponseSuccess(responseObject) {
                handler(responseObject.result.value, nil)
                return
            }
            if responseObject.result.isFailure {
                handler(nil, responseObject.result.error)
                return
            }
        }
    }

    public func delete(_ url: String, headers: [String: String]? = [:], _ handler: @escaping (Any?, Error?) -> Void) {
        Alamofire.request(url, method: .delete, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in

            if self.isHTTPResponseSuccess(responseObject) {
                handler(responseObject.result.value, nil)
                return
            }
            if responseObject.result.isFailure {
                handler(nil, responseObject.result.error)
                return
            }
        }
    }
    
    /**
     Check whether a response is successful.
    */
    private func isHTTPResponseSuccess(_ responseObject: DataResponse<Any>) -> Bool {
        return responseObject.result.isSuccess || (200..<300).contains(responseObject.response?.statusCode ?? 0)
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
