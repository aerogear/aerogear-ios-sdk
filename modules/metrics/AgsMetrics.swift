import AGSCore
import Foundation

/**
 * AeroGear Services metrics
 */
open class AgsMetrics {

    private let core: AgsCore
    private let appData: AppData
    private let config: MetricsConfig
    private var publisher: MetricsPublisher!

    public var metricsProcessors: [Collectable] = Array()

    public init() {
        core = AgsCore()
        appData = AppData()
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
        metricsProcessors.append(SdkVersionMetrics(appData))
    }

    /**
     * Force collect metrics
     */
    open func collectMetrics() {
        var metricsPayload: MetricsData = MetricsData()
        for metricsEngine: Collectable in metricsProcessors {
            let engineResult = metricsEngine.collect()
            metricsPayload.merge(engineResult) { _, new in new }
        }
        publisher.publish(metricsPayload)
    }
}
