import AGSCore
import Foundation

/**
    AeroGear Services Unified Push SDK

    SDK implements registration to Unified Push Server
    in order to corelate mobile clients for sending targeted messages.
 */
public class AgsPush {
    private static let serviceName = "push"

    public static let deviceTokenKey = "AgsPushSDK.deviceToken"
    public static let apiPath = "rest/registry/device"
    public static let instance: AgsPush = AgsPush(AgsCore.instance.getConfiguration(serviceName))

    struct DeviceRegistrationError {
        static let PushErrorDomain = "PushErrorDomain"
        static let NetworkingOperationFailingURLRequestErrorKey = "NetworkingOperationFailingURLRequestErrorKey"
        static let NetworkingOperationFailingURLResponseErrorKey = "NetworkingOperationFailingURLResponseErrorKey"
    }

    let serverURL: URL!
    let requestApi: AgsHttpRequestProtocol

    /**
     Initialise the push module

     - parameters:
        - mobileConfig: the configuration for the auth service from the service definition file
     */
    private init(_ mobileConfig: MobileService?) {
        self.serverURL = URL(string: (mobileConfig?.url)!)!
        self.requestApi = AgsCore.instance.getHttp()
    }

    /**
    Registers your mobile device to the AeroGear UnifiedPush server so it can start receiving messages.
    Registration information can be provided within clientInfo block

     - parameter clientInfo: A block object which passes in an implementation of the ClientDeviceInformation protocol that holds configuration metadata that would be posted to the server during the registration process.

     - parameter success: A block object to be executed when the registration operation finishes successfully. This block has no return value.

     - parameter failure: A block object to be executed when the registration operation finishes unsuccessfully.This block has no return value and takes one argument: The `NSError` object describing the error that occurred during the registration process.
    */
    @objc open func register(clientInfo: ((ClientDeviceInformation) -> Void)!,
                             success: (() -> Void)!, failure: ((NSError) -> Void)!) {
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
            clientInfoObject.deviceToken = UserDefaults.standard.object(forKey: AgsPush.deviceTokenKey) as? Data
        }
        guard let serverURLGuard = self.serverURL else {
            failure(NSError(domain: DeviceRegistrationError.PushErrorDomain, code: 0, userInfo: [NSLocalizedDescriptionKey: "'serverURL' should be set"]))
            return
        }

        validateClientInfoObject(clientInfoObject, failure)
        let headers = buildAuthHeaders(clientInfoObject)

        // serialize request
        let postData = clientInfoObject.extractValues()

        let registerUrl = serverURLGuard.appendingPathComponent(AgsPush.apiPath).absoluteString
        self.requestApi.post(registerUrl, body: postData, headers: headers, { data, error in
            if error != nil {
                failure(error as NSError!)
                return
            }
            self.saveClientDeviceInformation(clientInfoObject, serverURLGuard)
            success()
        })
    }

    // Storing data in UserDefaults
    fileprivate func saveClientDeviceInformation(_ clientInfoObject: ClientDeviceInformation, _ serverURLGuard: URL) {
        // locally stored information
        UserDefaults.standard.set(clientInfoObject.deviceToken, forKey: AgsPush.deviceTokenKey)
    }

    // Validate client information
    fileprivate func validateClientInfoObject(_ clientInfoObject: ClientDeviceInformation, _ failure: ((NSError) -> Void)) {
        // Fail if not all config mandatory items are present
        if clientInfoObject.deviceToken == nil {
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
    fileprivate func buildAuthHeaders(_ clientInfoObject: ClientDeviceInformationImpl) -> [String: String] {
        // apply HTTP Basic Extract method
        let basicAuthCredentials: Data! = "\(clientInfoObject.variantID!):\(clientInfoObject.variantSecret!)".data(using: String.Encoding.utf8)
        let base64Encoded = basicAuthCredentials.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        return ["Authorization": "Basic \(base64Encoded)"]
    }

}
