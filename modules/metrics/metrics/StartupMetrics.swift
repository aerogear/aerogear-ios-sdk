import Foundation

/**
 * Collects metrics for application startup time
 */
public class StartupMetrics: MetricsCollectable {
    public private(set) var identifier: String = ""

    public func collect() -> MetricsData {
        return ["startupTimestamp": "\(NSDate().timeIntervalSince1970 * 1000)"]
    }
}
