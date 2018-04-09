import Foundation

/**
   Metrics publisher that sends payload to remote server
   Publisher requires remote server URL
 */
public class MetricsNetworkPublisher: MetricsPublisher {
    let http: AgsHttpRequest
    let url: String

    init(_ http: AgsHttpRequest, _ url: String) {
        self.http = http
        self.url = url
    }

    public func publish(_ payload: MetricsData, _ handler: @escaping (AgsHttpResponse?) -> Void) {
        AgsCore.logger.debug("Sending metrics \(payload)")
        http.post(url, body: payload, { (response: AgsHttpResponse) -> Void in
            handler(response)
        })
    }
}
