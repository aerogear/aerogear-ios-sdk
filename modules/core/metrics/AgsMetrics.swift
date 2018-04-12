import Foundation

/**
 AeroGear Services metrics
 */
open class AgsMetrics: MetricsPublishable {
    
    private static let InitMetricsType = "init"
    
    private let appData: AgsMetaData
    private let config: MetricsConfig
    private var publisher: MetricsPublisher!
    private var http: AgsHttp

    private let defaultMetrics: [Metrics]

    public init(_ http: AgsHttp, _ configService: ServiceConfig) {
        self.http = http
        config = MetricsConfig(configService)
        appData = AgsCore.getMetadata()
        defaultMetrics = [AppMetrics(appData), DeviceMetrics()]
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
        publish(AgsMetrics.InitMetricsType, []) { (response: AgsHttpResponse?) -> Void in
            if let error = response?.error {
                AgsCore.logger.error("An error has occurred when sending app metrics: \(error)")
                return
            }
            if let response = response?.response as? [String: Any] {
                AgsCore.logger.debug("Metrics response \(response)")
            }
        }
    }

    fileprivate func appendMetrics(_ metrics: [Metrics], _ payload: inout [String: Any]) {
        for metric: Metrics in metrics {
            let result = metric.collect()
            payload[metric.identifier] = result
        }
    }

    open func publish(_ type: String, _ metrics: [Metrics], _ handler: @escaping (AgsHttpResponse?) -> Void) {
        var data = MetricsData()
        appendMetrics(metrics, &data)
        appendMetrics(defaultMetrics, &data)
        let payload = appendToRootMetrics(type, data)
        publisher.publish(payload, handler)
    }

    private func appendToRootMetrics(_ type: String, _ payload: MetricsData) -> [String: Any] {
        return [
            "clientId": appData.clientId,
            "timestamp": UInt64(NSDate().timeIntervalSince1970 * 1000),
            "type": type,
            "data": payload
        ]
    }
}
