 import Foundation

/**
 * Internal implementation of the ClientDeviceInformation protocol
 */
class ClientDeviceInformationImpl: NSObject, ClientDeviceInformation {

    var deviceToken: Data?
    var variantID: String?
    var variantSecret: String?
    var alias: String?
    var categories: [String]?
    var operatingSystem: String?
    var osVersion: String?
    var deviceType: String?
 
    override init() {
        super.init()        
    }
    
    // TODO replace with codable
    @objc func extractValues() -> [String: AnyObject] {
        var jsonObject =  [String: AnyObject]()
        
        jsonObject["deviceToken"] = convertToString(deviceToken) as AnyObject?
        jsonObject["alias"] = alias as AnyObject?
        jsonObject["categories"] = categories as AnyObject?
        jsonObject["operatingSystem"] = operatingSystem as AnyObject?
        jsonObject["osVersion"] = osVersion as AnyObject?
        jsonObject["deviceType"] = deviceType as AnyObject?

        return jsonObject;
    }

    // TODO this is not needed
    // Helper to transform the Data-based token into a (useful) String:
    fileprivate func convertToString(_ deviceToken: Data?) -> String? {
        if let token = (deviceToken as NSData?)?.description {
            return token.replacingOccurrences(of: "<", with: "")
                .replacingOccurrences(of: ">", with: "")
                .replacingOccurrences(of: " ", with: "")
        }
        
        return nil
    }

}
