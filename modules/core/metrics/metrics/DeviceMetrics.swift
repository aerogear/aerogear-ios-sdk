import Foundation

/**
 * Collect device metrics:
 *
 *  - platform - ios
 *  - platformVersion - version of the ios platform
 *  - device - device name
 */
public class DeviceMetrics: Metrics {
    public private(set) var identifier: String = "device"

    public func collect() -> MetricsData {
        return [
            "platform": "ios",
            "platformVersion": UIDevice.current.systemVersion,
            "device": UIDevice.current.model,
        ]
    }
}
