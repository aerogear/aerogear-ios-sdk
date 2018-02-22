import AGSCore
import Foundation

public class AppMetrics: MetricsCollectable {
    public private(set) var identifier: String = "app"

    let appData: AgsMetaData

    init(_ appData: AgsMetaData) {
        self.appData = appData
    }

    public func collect() -> MetricsData {
        return [
            "appId": self.appData.bundleId,
            "appVersion": self.appData.appVersion,
            "sdkVersion": self.appData.sdkVersion
        ]
    }
}