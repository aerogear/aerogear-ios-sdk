import AGSCore
import Foundation

/**
 * Represents single metrics data
 */
public typealias MetricsData = [String: Any]

/**
 * Protocol for classes that can publish or store metrics payload
 */
public protocol MetricsPublisher {
    /**
     * Allows to publish metrics to external source
     */
    func publish(_ payload: MetricsData)
}

/**
 * Metrics publisher that logs metrics to console
 * Can be used when remote server is not available/supported
 */
public class MetricsLoggerPublisher: MetricsPublisher {
    public func publish(_ payload: MetricsData) {
        AgsCore.logger.info("Metrics collected \(payload)")
    }
}
