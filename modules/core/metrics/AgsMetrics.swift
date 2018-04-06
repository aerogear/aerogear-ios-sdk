import Foundation

/**
 AeroGear Services metrics
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
     Set default metrics publisher depending on metrics configuration
     */
    open func setDefaultPublisher() {
        if let url = config.getRemoteMetricsUrl() {
            setMetricsPublisher(MetricsNetworkPublisher(http.getHttp(), url))
        } else {
            setMetricsPublisher(MetricsLoggerPublisher(appData.clientId))
        }
    }

    /**
     Allows to override default metrics publisher

     - Parameter publisher: implementation of metrics publisher
     */
    public func setMetricsPublisher(_ publisher: MetricsPublisher) {
        self.publisher = publisher
    }

    /**
     Collect metrics for all active metrics collectors
     Send data using metrics publisher
     */
    open func sendAppAndDeviceMetrics() {
        publish([AppMetrics(appData), DeviceMetrics()]) { (response: AgsHttpResponse?) -> Void in
            if let error = response?.error {
                AgsCore.logger.error("An error has occurred when sending app metrics: \(error)")
                return
            }
            if let response = response?.response as? [String: Any] {
                AgsCore.logger.debug("Metrics response \(response)")
            }
        }
    }

    /**
     Publish metrics using predefined publisher

     - Parameter metrics: instances that should be published
     - Parameter handler: handler for success/failire
     */
    open func publish(_ metrics: [Metrics], _ handler: @escaping (AgsHttpResponse?) -> Void) {
        var payload = MetricsData()
        for metric: Metrics in metrics {
            let result = metric.collect()
            payload[metric.identifier] = result
        }
        publisher.publish(appendToRootMetrics(payload), handler)
    }

    private func appendToRootMetrics(_ payload: MetricsData) -> [String: Any] {
        return [
            "clientId": appData.clientId,
            "timestamp": UInt64(NSDate().timeIntervalSince1970 * 1000),
            "data": payload
        ]
    }
}
