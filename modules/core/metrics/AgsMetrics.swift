import Foundation

/**
 * AeroGear Services metrics
 */
open class AgsMetrics: MetricsContainer {

    private let core: AgsCore
    private let appData: AgsMetaData
    private let config: MetricsConfig
    private var publisher: MetricsPublisher!

    private var metricsCollectors: [MetricsCollectable] = Array()

    public init(_ core: AgsCore) {
        self.core = core
        appData = AgsCore.getMetadata()
        config = MetricsConfig(core)

        injectPublisher()
        enableDefaultMetrics()
    }

    /**
     * Injects publisher
     */
    open func injectPublisher() {
        if let url = config.getRemoteMetricsUrl() {
            setMetricsPublisher(MetricsNetworkPublisher(core.getHttp(), url, appData.clientId))
        } else {
            setMetricsPublisher(MetricsLoggerPublisher(appData.clientId))
        }
    }

    /**
     * Allows to override default metrics publisher
     *
     * @param publisher - implementation of metrics publisher
     */
    public func setMetricsPublisher(_ publisher: MetricsPublisher) {
        self.publisher = publisher
    }

    /**
     * Method can be extended to initialize specific set of metrics
     */
    open func enableDefaultMetrics() {
        metricsCollectors.append(AppMetrics(appData));
        metricsCollectors.append(DeviceMetrics())
    }

    /**
     * Add new collector to metrics. Collectors allow to collect and append mobile metrics
     * @see Collectable
     * @param collector - new metrics implementation to be added
     */
    private func addMetricsCollector(_ collector: MetricsCollectable) {
        metricsCollectors.append(collector)
    }

    /**
     * Collect metrics for all active metrics collectors
     * Send data using metrics publisher
     */
    open func sendDefaultMetrics() {
        publish(metricsCollectors)
    }

    /**
     * Publish user defined metrics. Can be used by other SDK  modules too
     */
    open func publish(_ metrics: MetricsCollectable...) {
        publish(metrics)
    }

    /**
      * Internal publish function that accepts an array and can be used by either
      * passing an array or variadic args
      */
    private func publish(_ metrics: [MetricsCollectable]) {
        var payload = MetricsData()
        for metric: MetricsCollectable in metrics {
            let result = metric.collect()
            payload[metric.identifier] = result
        }
        publisher.publish(payload)
    }
}
