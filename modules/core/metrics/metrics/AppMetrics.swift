import Foundation

/**
 * Collect application metrics:
 *
 *  - appId - application bundle id
 *  - appVersion - version of the applicatoon
 *  - sdkVersion - AeroGear Services SDK version
 */
public class AppMetrics: Metrics {
    public private(set) var identifier: String = "app"

    let appData: AgsMetaData

    init(_ appData: AgsMetaData) {
        self.appData = appData
    }

    public func collect() -> MetricsData {
        return [
            "appId": self.appData.bundleId,
            "appVersion": self.appData.appVersion,
            "sdkVersion": self.appData.sdkVersion,
        ]
    }
}
