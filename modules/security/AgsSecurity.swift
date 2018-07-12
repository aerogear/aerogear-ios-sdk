import AGSCore
import Foundation

/**
 AeroGear Services Security SDK

 SDK provides a way for the developer to perform security
 checks on the device their code is running on
 */
public class AgsSecurity {

    private let serviceId = "security"
    
    public static let instance: AgsSecurity = AgsSecurity()

    /**
     The initialise method of AgsSecurity
    */
    public init() {}

    /**
     - Perform a security check on a device.

     - Parameter check: The security check to be performed
     - Returns: A SecurityCheckResult with a true or false property 'passed'
     */
    public func check(_ check: SecurityCheck) -> SecurityCheckResult {
        return check.check()
    }

    /**
     - Perform a security check on a device and also publish the result to the metrics service

     - Parameter check: The security check to be performed
     - Returns: A SecurityCheckResult with a true or false property 'passed'
    */
    public func checkAndPublishMetric(_ check: SecurityCheck) -> SecurityCheckResult {
        let result = check.check()
        AgsCore.instance.getMetrics().publish(serviceId, [SecurityCheckResultMetric([result])], { (response: AgsHttpResponse?) -> Void in
            if let error = response?.error {
                AgsCore.logger.error("An error has occurred when sending check metrics: \(error)")
                return
            }
            if let response = response?.response as? [String: Any] {
                AgsCore.logger.debug("Metrics response \(response)")
            }
        })
        return result
    }

    /**
     - Perform multiple security checks on a device

     - Parameter checks: The security checks to be performed
     - Returns: An array of type SecurityCheckResult with a true or false property 'passed' for each result
     */
    public func checkMany(_ checks: [SecurityCheck]) -> [SecurityCheckResult] {
        var completedChecks: [SecurityCheckResult] = []
        for value in checks {
            completedChecks.append(check(value))
        }
        return completedChecks
    }

    /**
     - Perform multiple security checks on a device and also publish them to the metrics service

     - Parameter checks: The security checks to be performed
     - Returns: An array of type SecurityCheckResult with a true or false property 'passed' for each result
     */
    public func checkManyAndPublishMetric(_ checks: [SecurityCheck]) -> [SecurityCheckResult] {
        let results = checkMany(checks)
        let securityResults = SecurityCheckResultMetric(results)
        AgsCore.instance.getMetrics().publish(serviceId, [securityResults], { (response: AgsHttpResponse?) -> Void in
            if let error = response?.error {
                AgsCore.logger.error("An error has occurred when sending app metrics: \(error)")
                return
            }
            if let response = response?.response as? [String: Any] {
                AgsCore.logger.debug("Metrics response \(response)")
            }
        })
        return results
    }
}
