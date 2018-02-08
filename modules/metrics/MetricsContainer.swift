import Foundation

/**
 * Protocol used for mobile metrics management
 * Allows other SDK and implementations to manage (add) metrics
 */
public protocol MetricsContainer {

    /**
     * Add new collector to metrics. Collectors allow to collect and append mobile metrics
     * Note: Collectors should be added before metrics are processed
     * @param collector - new metrics implementation to be added
     * @see Collectable
     */
    func addMetricsCollector(_ collector: MetricsCollectable)

    /**
     * Allows to override default metrics publisher
     *
     * @param publisher - implementation of metrics publisher
     */
    func setMetricsPublisher(_ publisher: MetricsPublisher)

    /**
     * Collect metrics for all active metrics collectors
     * Send data using metrics publisher
     */
    func collectMetrics()
}
