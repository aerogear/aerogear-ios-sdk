import AGSCore
import Foundation

public class DeviceMetrics: MetricsCollectable {
    public private(set) var identifier: String = "device"

    public func collect() -> MetricsData {
        return [
            "platform": "ios",
            "platformVersion": UIDevice.current.systemVersion,
            "device": UIDevice.current.model
        ]
    }
}
