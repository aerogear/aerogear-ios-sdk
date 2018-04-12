import Foundation

/**
 Protocol used for mobile metrics management
 Allows other SDK and implementations to manage (add) metrics
 */
public protocol MetricsPublishable {
    /**
     Allows to override default metrics publisher

     - Parameter publisher: implementation of metrics publisher
     */
    func setMetricsPublisher(_ publisher: MetricsPublisher)

    /**
     Collect application and device metrics
     Send data instantly using active metrics publisher
     */
    func sendAppAndDeviceMetrics()

    /**
     Publish user defined metrics

         - Parameter type: represents metrics type
         - Parameter metrics: instances that should be published
         - Parameter handler: handler for success/failire
     */
    func publish(_ type: String, _ metrics: [Metrics], _ handler: @escaping (AgsHttpResponse?) -> Void)
}
