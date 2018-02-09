import Foundation

/**
 * Collects metrics for application startup time
 */
public class StartupMetrics: MetricsCollectable {

    public func collect() -> MetricsData {
        return ["startupTimestamp": "\(NSDate().timeIntervalSince1970 * 1000)"]
    }
}
