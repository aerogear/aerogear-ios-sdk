import Foundation

/**
 * Protocol used for for classes that will colect metrics
 */
public protocol Metrics {
    /**
     * A identifier that is used to namespace the metrics data
     *
     * @return identifier string
     */
    var identifier: String { get }

    /**
     * Function called when metrics need to be collected
     *
     * @return metrics dictionary object that contains metrics data
     */
    func collect() -> MetricsData
}
