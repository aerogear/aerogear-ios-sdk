import Foundation

/**
 * Protocol used for mobile metrics management
 * Allows other SDK and implementations to manage (add) metrics
 */
public protocol MetricsContainer {
    
    /**
    * Default instance for metrics container
    */
    static var instance: MetricsContainer { get }

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
    func sendDefaultMetrics()

    /**
     * Publish user defined metrics
     *
     * @param metrics Varargs of objects implementing MetricsCollectable
     */
    func publish(_ metrics: MetricsCollectable...)
}
