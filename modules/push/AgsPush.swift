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

    let serverURL: URL
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

     - parameter config: Metadata that would be posted to the server during the registration process.

     - parameter credentials: Credentials used to register the device

     - parameter success: A block object to be executed when the registration operation finishes successfully. This block has no return value.

     - parameter failure: A block object to be executed when the registration operation finishes unsuccessfully.This block has no return value and takes one argument: The `NSError` object describing the error that occurred during the registration process.
    */
    public func register(_ deviceToken: Data,
                         _ config: UnifiedPushConfig,
                         _ credentials: UnifiedPushCredentials,
                         success: @escaping (() -> Void),
                         failure: @escaping ((NSError) -> Void)) {

        let currentDevice = UIDevice()

        let headers = buildAuthHeaders(credentials)

        let postData = [
            "deviceToken": convertToString(deviceToken) as Any,
            "deviceType": currentDevice.model,
            "operatingSystem": currentDevice.systemName,
            "osVersion": currentDevice.systemVersion,
            "alias": config.alias ?? "",
            "categories": config.categories ?? ""
        ] as [String: Any]

        let registerUrl = self.serverURL.appendingPathComponent(AgsPush.apiPath).absoluteString
        self.requestApi.post(registerUrl, body: postData, headers: headers) { (response) -> Void in
            if let error = response.error {
                failure(error as NSError)
                return
            }
            self.saveClientDeviceInformation(deviceToken, self.serverURL)
            success()
        }
    }

    // Storing data in UserDefaults
    fileprivate func saveClientDeviceInformation(_ token: Data, _ serverURLGuard: URL) {
        // locally stored information
        UserDefaults.standard.set(token, forKey: AgsPush.deviceTokenKey)
    }

    // Build headers used for Authentication
    fileprivate func buildAuthHeaders(_ credentials: UnifiedPushCredentials) -> [String: String] {
        // apply HTTP Basic Extract method
        let basicAuthCredentials: Data! = "\(credentials.variantID):\(credentials.variantSecret)".data(using: String.Encoding.utf8)
        let base64Encoded = basicAuthCredentials.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        return ["Authorization": "Basic \(base64Encoded)"]
    }

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
