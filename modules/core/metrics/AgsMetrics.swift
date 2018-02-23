import Foundation

/**
 * AeroGear Services metrics
 */
open class AgsMetrics: MetricsPublishable {

    private let appData: AgsMetaData
    private let config: MetricsConfig
    private var publisher: MetricsPublisher!
    private var http: AgsHttp

    public init(_ http: AgsHttp, _ configService: ServiceConfig) {
        self.http = http
        config = MetricsConfig(configService)
        appData = AgsCore.getMetadata()
        setDefaultPublisher()
    }

    /**
     * Set default metrics publisher depending on metrics configuration
     *
     * @see MetricsNetworkPublisher
     * @see MetricsLoggerPublisher
     */
    open func setDefaultPublisher() {
        if let url = config.getRemoteMetricsUrl() {
            setMetricsPublisher(MetricsNetworkPublisher(http.getHttp(), url))
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
     * Collect metrics for all active metrics collectors
     * Send data using metrics publisher
     */
    open func sendAppAndDeviceMetrics() {
        publish(AppMetrics(appData), DeviceMetrics())
    }

    /**
     * Publish metrics using predefined publisher
     *
     * @param - metrics instances that should be published
     */
    open func publish(_ metrics: Metrics...) {
        var payload = MetricsData()
        for metric: Metrics in metrics {
            let result = metric.collect()
            payload[metric.identifier] = result
        }
        payload = metricsRoot().merging(payload) { orig, _ in orig }
        publisher.publish(payload)
    }

    private func metricsRoot() -> [String: Any] {
        return [
            "clientId": appData.clientId,
            "timestamp": "\(NSDate().timeIntervalSince1970 * 1000)",
        ]
    }
}
