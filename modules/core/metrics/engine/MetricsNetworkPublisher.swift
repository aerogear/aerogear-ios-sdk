import Foundation

/**
 * Metrics publisher that sends payload to remote server
 * Publisher requires remote server URL
 */
public class MetricsNetworkPublisher: MetricsPublisher {
    
    let http: AgsHttpRequest
    let url: String

    init(_ http: AgsHttpRequest, _ url: String) {
        self.http = http
        self.url = url
    }

    public func publish(_ payload: MetricsData) {
        AgsCore.logger.debug("Sending metrics \(payload)")
        http.post(url, body: payload, { (response, error) -> Void in
            if let error = error {
                AgsCore.logger.error("An error has occurred when sending app metrics: \(error)")
                return
            }
            if let response = response as? [String: Any] {
                AgsCore.logger.debug("Metrics response \(response)")
            }
        })
    }
}
