import AGSCore
import Foundation

/**
 * Structure respresents payload for SDK version metrics
 */
public struct SdkVersion: Codable {
    /** Unique ID for mobile installation */
    public let clientId: String
    /** SDK version */
    public let sdkVersion: String
    /** Application bundle name */
    public let appId: String
    /** Application version number */
    public let appVersion: String
}

/**
 * Collects metrics for SDK and application versions
 */
public class SdkVersionMetrics: Collectable {
    let http: AgsHttpRequest
    let config: MetricsConfig
    let appData: AppData
    var sdkVersion: String

    init(_ http: AgsHttpRequest, _ config: MetricsConfig, _ appData: AppData) {
        self.http = http
        self.config = config
        self.appData = appData
        sdkVersion = AgsCore.getMetadata().SDK_VERSION
    }

    func collect() {
        // TODO: Store version in User Preferences and detect that was changed?
        // TODO: use single endpoint vs dedicated one?
        if let uri = config.getBaseUrl() {
            let payload = SdkVersion(clientId: appData.installationID,
                                     sdkVersion: sdkVersion,
                                     appId: appData.bundleId,
                                     appVersion: appData.appVersion
            )

            AgsCore.logger.debug("Sending metrics \(payload)")
            let requestDictionary = try? payload.adaptToDictionary()
            http.post(uri, body: requestDictionary, { (response, error) -> Void in
                if let error = error {
                    AgsCore.logger.error("An error has occurred when sending app metrics: \(error)")
                    return
                }
                if let response = response as? [String: Any] {
                    AgsCore.logger.debug("Metrics response \(response)")
                }
            })
        } else {
            AgsCore.logger.warning("Mobile version tracking is disabled. Missing metrics uri")
            return
        }
    }
}
