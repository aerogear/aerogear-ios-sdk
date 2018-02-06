import Alamofire
import Foundation

/**
 * This is a implementation of HttpRequest based on AlamoFire
 * Implementation is designed to work with Json payload
 */
public class AgsHttpRequest {

    public func get(_ url: String, params: [String: AnyObject]? = [:], headers: [String: String]? = [:],
                    _ handler: @escaping (Any?, Error?) -> Void) {
        Alamofire.request(url, parameters: params, headers: headers).responseJSON { (responseObject) -> Void in
            if responseObject.result.isSuccess {
                handler(responseObject.result.value, nil)
            }
            if responseObject.result.isFailure {
                handler(nil, responseObject.result.error)
            }
        }
    }

    public func post(_ url: String, body: [String: Any]? = [:], headers: [String: String]? = [:], _ handler: @escaping (Any?, Error?) -> Void) {
        Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            if responseObject.result.isSuccess {
                handler(responseObject.result.value, nil)
            }
            if responseObject.result.isFailure {
                handler(nil, responseObject.result.error)
            }
        }
    }

    public func put(_ url: String, body: [String: Any]? = [:], headers: [String: String]? = [:], _ handler: @escaping (Any?, Error?) -> Void) {
        Alamofire.request(url, method: .put, parameters: body, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in

            if responseObject.result.isSuccess {
                handler(responseObject.result.value, nil)
            }
            if responseObject.result.isFailure {
                handler(nil, responseObject.result.error)
            }
        }
    }

    public func delete(_ url: String, headers: [String: String]? = [:], _ handler: @escaping (Any?, Error?) -> Void) {
        Alamofire.request(url, method: .delete, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in

            if responseObject.result.isSuccess {
                handler(responseObject.result.value, nil)
            }
            if responseObject.result.isFailure {
                handler(nil, responseObject.result.error)
            }
        }
    }
}

/**
 * Extending encodable in order to support Encodable => Dictionary conversion
 */
public extension Encodable {
    /**
     * Encodable => Dictionary conversion
     */
    public func adaptToDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
}
