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

    let appData: AppData
    var sdkVersion: String

    init(_ appData: AppData) {
        self.appData = appData
        sdkVersion = AgsCore.getMetadata().SDK_VERSION
    }

    public func collect() -> MetricsData {
        let payload = SdkVersion(clientId: appData.installationID,
                                 sdkVersion: sdkVersion,
                                 appId: appData.bundleId,
                                 appVersion: appData.appVersion
        )

        return try! payload.adaptToDictionary()
    }
}
