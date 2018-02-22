import Foundation

/**
 * Metrics publisher that sends payload to remote server
 * Publisher requires remote server URL
 */
public class MetricsNetworkPublisher: MetricsPublisher {
    let clientId: String
    let http: AgsHttpRequest
    let url: String

    init(_ http: AgsHttpRequest, _ url: String, _ clientId: String) {
        self.http = http
        self.url = url
        self.clientId = clientId
    }

    private func metricsRoot() -> [String: Any] {
        return [
            "clientId": self.clientId,
            "timestamp": "\(NSDate().timeIntervalSince1970 * 1000)"
        ]
    }

    public func publish(_ payload: MetricsData) {

        let data = metricsRoot().merging(payload) { orig, _ in orig }

        AgsCore.logger.debug("Sending metrics \(data)")
        http.post(url, body: data, { (response, error) -> Void in
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
