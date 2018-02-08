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

    let appData: AgsMetaData

    init(_ appData: AgsMetaData) {
        self.appData = appData
    }

    public func collect() -> MetricsData {
        let payload = SdkVersion(clientId: appData.installationId,
                                 sdkVersion: appData.sdkVersion,
                                 appId: appData.bundleId,
                                 appVersion: appData.appVersion
        )
        let dictionary = try? payload.adaptToDictionary()
        return dictionary ?? MetricsData()
    }
}
