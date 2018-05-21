import Foundation

/**
 AeroGear Services metrics
 */
open class AgsMetrics {
    // Default metrics type
    private static let InitMetricsType = "init"
    // Default timeout for starting metrics
    private static let DefaultMetricsTimeout = 5.0

    private let appData: AgsMetaData
    private let config: MetricsConfig
    private var publisher: MetricsPublisher?
    private var http: AgsHttp

    private let defaultMetrics: [Metrics]

    public init(_ http: AgsHttp, _ configService: ServiceConfig) {
        self.http = http
        config = MetricsConfig(configService)
        appData = AgsCore.getMetadata()
        defaultMetrics = [AppMetrics(appData), DeviceMetrics()]
        setDefaultPublisher()
        self.sendAppAndDeviceMetrics()
    }

    /**
     Set default metrics publisher depending on metrics configuration
     */
    private func setDefaultPublisher() {
        if let url = config.getRemoteMetricsUrl() {
            self.publisher = MetricsNetworkPublisher(http.getHttp(), url)
        }
    }

    /**
     Collect metrics for all active metrics collectors
     Send data using metrics publisher
     */
    private func sendAppAndDeviceMetrics() {
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

    /**
     Internal method for publishing SDK defined metrics.
     Not to be called in end user application

     - Parameter type: represents metrics type
     - Parameter metrics: instances that should be published
     - Parameter handler: handler for success/failire
     */
    public func publish(_ type: String, _ metrics: [Metrics], _ handler: @escaping (AgsHttpResponse?) -> Void) {
        guard let activePublisher = publisher else {
            return
        }
        var data = MetricsData()
        appendMetrics(metrics, &data)
        appendMetrics(defaultMetrics, &data)
        let payload = appendToRootMetrics(type, data)
        activePublisher.publish(payload, handler)
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
