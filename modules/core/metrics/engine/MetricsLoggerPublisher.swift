import Foundation

/**
   Metrics publisher that logs metrics to console
   Can be used when remote server is not available/supported
 */
public class MetricsLoggerPublisher: MetricsPublisher {
    let clientId: String

    init(_ clientId: String) {
        self.clientId = clientId
    }

    public func publish(_ payload: MetricsData, _ handler: @escaping (AgsHttpResponse?) -> Void) {
        AgsCore.logger.info("Metrics collected [\(clientId)]: \(payload)")
        handler(nil)
    }
}
