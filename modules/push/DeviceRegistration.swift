import Foundation
import AGSCore

/**
 Utility to register an iOS device with the AeroGear UnifiedPush Server.
 */
open class DeviceRegistration: NSObject {
    
    struct DeviceRegistrationError {
        static let PushErrorDomain = "PushErrorDomain"
        static let NetworkingOperationFailingURLRequestErrorKey = "NetworkingOperationFailingURLRequestErrorKey"
        static let NetworkingOperationFailingURLResponseErrorKey = "NetworkingOperationFailingURLResponseErrorKey"
    }
    
    var serverURL: URL!
    var requestApi: AgsHttpRequestProtocol;
    
    /**
     An initializer method to instantiate an DeviceRegistration object.
    
     - parameter serverURL: the URL of the AeroGear Push server.
     - returns: the DeviceRegistration object.
    */
    @objc public init(_ serverURL: URL,_ requestApi: AgsHttpRequestProtocol) {
        self.serverURL = serverURL;
        self.requestApi = requestApi;
        super.init()
    }
    
    /**
    Registers your mobile device to the AeroGear UnifiedPush server so it can start receiving messages.
    Registration information can be provided within clientInfo block
    
     - parameter clientInfo: A block object which passes in an implementation of the ClientDeviceInformation protocol that holds configuration metadata that would be posted to the server during the registration process.

     - parameter success: A block object to be executed when the registration operation finishes successfully. This block has no return value.
    
     - parameter failure: A block object to be executed when the registration operation finishes unsuccessfully.This block has no return value and takes one argument: The `NSError` object describing the error that occurred during the registration process.
    */
    @objc open func register(clientInfo: ((ClientDeviceInformation) -> Void)!,
        success:(() -> Void)!, failure:((NSError) -> Void)!) -> Void {

        // can't proceed with no configuration block set
        guard let clientInfoConfigurationBlock = clientInfo else {
            failure(NSError(domain: DeviceRegistrationError.PushErrorDomain, code: 0, userInfo: [NSLocalizedDescriptionKey: "configuration block not set"]))
            return
        }

        let clientInfoObject = ClientDeviceInformationImpl()
        clientInfoConfigurationBlock(clientInfoObject)

        // deviceToken could be nil then retrieved it from local storage (from previous register).
        // This is the use case when you update categories.
        if clientInfoObject.deviceToken == nil {
            clientInfoObject.deviceToken = UserDefaults.standard.object(forKey: "AgsPush.deviceToken") as? Data
        }
        guard let serverURLGuard = self.serverURL else {
            failure(NSError(domain: DeviceRegistrationError.PushErrorDomain, code: 0, userInfo: [NSLocalizedDescriptionKey: "'serverURL' should be set"]))
            return
        }
    
        validateClientInfoObject(clientInfoObject, failure);
        saveClientDeviceInformation(clientInfoObject, serverURLGuard)
        let headers = buildAuthHeaders(clientInfoObject)
      
        // serialize request
        let postData = clientInfoObject.extractValues()
    
        let registerUrl = serverURLGuard.appendingPathComponent("rest/registry/device").absoluteString;
        self.requestApi.post(registerUrl,body:postData,headers:headers, {(data, error) in
            if error != nil {
                failure(error as NSError!)
                return
            }
            success();
        });
    }
    
    // Storing data in UserDefaults
    fileprivate func saveClientDeviceInformation(_ clientInfoObject: ClientDeviceInformation, _ serverURLGuard: URL) {
        // locally stored information
        UserDefaults.standard.set(clientInfoObject.deviceToken, forKey: "AgsPushSDK.deviceToken")
        UserDefaults.standard.set(clientInfoObject.variantID, forKey: "AgsPushSDK.variantID")
        UserDefaults.standard.set(clientInfoObject.variantSecret, forKey: "AgsPushSDK.variantSecret")
        UserDefaults.standard.set(serverURLGuard.absoluteString, forKey: "AgsPushSDK.serverURL")
    }
    
    // Validate client information
    fileprivate func validateClientInfoObject(_ clientInfoObject: ClientDeviceInformation, _ failure:((NSError) -> Void)) {
        // Fail if not all config mandatory items are present
        if clientInfoObject.deviceToken == nil  {
            failure(NSError(domain: DeviceRegistrationError.PushErrorDomain, code: 0, userInfo: [NSLocalizedDescriptionKey: "'token' should be set"]))
            return
        }
        
        if clientInfoObject.variantID == nil {
            failure(NSError(domain: DeviceRegistrationError.PushErrorDomain, code: 0, userInfo: [NSLocalizedDescriptionKey: "'variantID' should be set"]))
            return
        }
        
        if clientInfoObject.variantSecret == nil {
            failure(NSError(domain: DeviceRegistrationError.PushErrorDomain, code: 0, userInfo: [NSLocalizedDescriptionKey: "'variantSecret' should be set"]))
            return
        }
    }
    
    // Build headers used for Authentication
    fileprivate func buildAuthHeaders(_ clientInfoObject: ClientDeviceInformationImpl) -> [String : String] {
        // apply HTTP Basic Extract method
        let basicAuthCredentials: Data! = "\(clientInfoObject.variantID!):\(clientInfoObject.variantSecret!)".data(using: String.Encoding.utf8)
        let base64Encoded = basicAuthCredentials.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        return ["Authorization":"Basic \(base64Encoded)"];
        
    }
}
