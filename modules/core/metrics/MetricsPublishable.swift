import Foundation

/**
 * Protocol used for mobile metrics management
 * Allows other SDK and implementations to manage (add) metrics
 */
public protocol MetricsPublishable {
    /**
     * Allows to override default metrics publisher
     *
     * @param publisher - implementation of metrics publisher
     */
    func setMetricsPublisher(_ publisher: MetricsPublisher)

    /**
     * Collect application and device metrics
     * Send data instantly using active metrics publisher
     */
    func sendAppAndDeviceMetrics()

    /**
     * Publish user defined metrics
     *
     * @param metrics Varargs of objects implementing MetricsCollectable
     */
    func publish(_ metrics: Metrics...)
}
