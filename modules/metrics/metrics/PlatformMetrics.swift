

import Foundation

/**
 * Collects metrics for IOS platform and device types
 */
public class PlatformMetrics: MetricsCollectable {
    public private(set) var identifier: String = ""

    public func collect() -> MetricsData {
        return ["platform": "ios",
                "platformVersion" : UIDevice.current.systemVersion,
                "device" : UIDevice.current.model]
    }
}
