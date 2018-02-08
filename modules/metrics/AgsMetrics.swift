import AGSCore
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

    public init() {
        core = AgsCore()
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
            setMetricsPublisher(MetricsNetworkPublisher(core.getHttp(), url))
        } else {
            setMetricsPublisher(MetricsLoggerPublisher())
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
        metricsCollectors.append(SdkVersionMetrics(appData))
        metricsCollectors.append(StartupMetrics())
    }

    /**
     * Add new collector to metrics. Collectors allow to collect and append mobile metrics
     * @see Collectable
     * @param collector - new metrics implementation to be added
     */
    open func addMetricsCollector(_ collector: MetricsCollectable) {
        metricsCollectors.append(collector)
    }

    /**
     * Collect metrics for all active metrics collectors
     * Send data using metrics publisher
     */
    open func collectMetrics() {
        var metricsPayload: MetricsData = MetricsData()
        for metricsEngine: MetricsCollectable in metricsCollectors {
            let engineResult = metricsEngine.collect()
            metricsPayload.merge(engineResult) { _, new in new }
        }
        publisher.publish(metricsPayload)
    }
}
