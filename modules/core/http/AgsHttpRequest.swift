import Alamofire
import Foundation

/**
 * This is a implementation of HttpRequest based on AlamoFire
 * Implementation is designed to work with Json payload
 */
public class AgsHttpRequest {

    public func get(_ url: String, params: [String: AnyObject]? = [:], headers: [String: String]? = [:],
                    _ handler : @escaping (Any?, Error?) -> Void) {
        Alamofire.request(url, parameters: params, headers: headers).responseJSON { (responseObject) -> Void in
            if responseObject.result.isSuccess {
                handler(responseObject.result.value, nil)
            }
            if responseObject.result.isFailure {
                handler(nil, responseObject.result.error)
            }
        }
    }

    public func post(_ url: String, body: [String: AnyObject]? = [:], headers: [String: String]? = [:], _ handler: @escaping (Any?, Error?) -> Void) {
        Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            if responseObject.result.isSuccess {
                handler(responseObject.result.value, nil)
            }
            if responseObject.result.isFailure {
                handler(nil, responseObject.result.error)
            }
        }
    }

    public func put(_ url: String, body: [String: AnyObject]? = [:], headers: [String: String]? = [:], _ handler: @escaping (Any?, Error?) -> Void) {
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
