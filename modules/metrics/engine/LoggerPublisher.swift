import AGSCore
import Foundation

/**
 * Metrics publisher that logs metrics to console
 * Can be used when remote server is not available/supported
 */
public class MetricsLoggerPublisher: MetricsPublisher {
    public func publish(_ payload: MetricsData) {
        AgsCore.logger.info("Metrics collected \(payload)")
    }
}
