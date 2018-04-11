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

    public static let instance: AgsPush = {
        let config = AgsCore.instance.getConfiguration(serviceName)
        let httpInterface = AgsCore.instance.getHttp()
        return AgsPush(config, httpInterface)
    }()

    struct DeviceRegistrationError {
        static let PushErrorDomain = "PushErrorDomain"
        static let NetworkingOperationFailingURLRequestErrorKey = "NetworkingOperationFailingURLRequestErrorKey"
        static let NetworkingOperationFailingURLResponseErrorKey = "NetworkingOperationFailingURLResponseErrorKey"
    }

    let requestApi: AgsHttpRequestProtocol
    let serverURL: URL
    let credentials: UnifiedPushCredentials

    /**
     Initialise the push module

     - parameters:
        - mobileConfig: the configuration for the auth service from the service definition file
        - requestApi: http implementation
     */
    init(_ mobileConfig: MobileService?, _ requestApi: AgsHttpRequestProtocol) {
        self.requestApi = requestApi
        self.serverURL = URL(string: (mobileConfig?.url)!)!

        let pushSecurityConfig = mobileConfig?.config!["ios"]?.getObject()
        let variant = pushSecurityConfig?["variantId"]?.getString()
        let secret = pushSecurityConfig?["variantSecret"]?.getString()

        self.credentials = UnifiedPushCredentials(variant!, secret!)
    }

    /**
    Registers your mobile device to the AeroGear UnifiedPush server so it can start receiving messages.
    Registration information can be provided within clientInfo block

     - parameter config: Metadata that would be posted to the server during the registration process.

     - parameter credentials: Credentials used to register the device

     - parameter success: A block object to be executed when the registration operation finishes successfully. This block has no return value.

     - parameter failure: A block object to be executed when the registration operation finishes unsuccessfully.This block has no return value and takes one argument: The `Error` object describing the error that occurred during the registration process.
    */
    public func register(_ deviceToken: Data,
                         _ config: UnifiedPushConfig,
                         success: @escaping (() -> Void),
                         failure: @escaping ((Error) -> Void)) {
        let currentDevice = UIDevice()

        let headers = buildAuthHeaders(self.credentials)

        let postData = [
            "deviceToken": convertToString(deviceToken) as Any,
            "deviceType": currentDevice.model,
            "operatingSystem": currentDevice.systemName,
            "osVersion": currentDevice.systemVersion,
            "alias": config.alias ?? "",
            "categories": config.categories ?? ""
        ] as [String: Any]

        let registerUrl = self.serverURL.appendingPathComponent(AgsPush.apiPath).absoluteString
        self.requestApi.post(registerUrl, body: postData, headers: headers, { response in
            guard let requestError = response.error else {
                self.saveClientDeviceInformation(deviceToken, self.serverURL)
                success()
                return
            }
            failure(requestError)
        })
    }

    // Storing data in UserDefaults
    fileprivate func saveClientDeviceInformation(_ token: Data, _ serverURLGuard: URL) {
        // locally stored information
        UserDefaults.standard.set(token, forKey: AgsPush.deviceTokenKey)
    }

    // Build headers used for Authentication
    fileprivate func buildAuthHeaders(_ credentials: UnifiedPushCredentials) -> [String: String] {
        // apply HTTP Basic Extract method
        let basicAuthCredentials: Data! = "\(self.credentials.variantID):\(self.credentials.variantSecret)".data(using: String.Encoding.utf8)
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
