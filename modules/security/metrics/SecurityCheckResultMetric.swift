import AGSCore
import Foundation
/**
 Collecting metrics for security checks

 */
public class DeviceCheckResultMetric: Metrics {

    /**
     An identifier that is used to namespace the metrics data
     */
    public let identifier = "security"

    private var results: [DeviceCheckResult]

    init(_ results: [DeviceCheckResult]) {
        self.results = results
    }

    public func collect() -> MetricsData {
        var collectArray: [Any] = []
        for result in self.results {
            do {
                let singleCheck = try result.adaptToDictionary()
                let mappedObj = [
                    "name": singleCheck["name"] ?? "",
                    "passed": singleCheck["passed"] ?? "",
                    "id": singleCheck["name"] ?? ""
                ]
                collectArray.append(mappedObj)
            } catch {
                AgsCore.logger.error("An error has occurred when collecting device check metrics: \(error)")
            }
        }

        return collectArray
    }
}
