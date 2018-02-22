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
