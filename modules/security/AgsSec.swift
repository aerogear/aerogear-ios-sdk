import Foundation

/**
 AeroGear Services Security SDK
 
 SDK provides a way for the developer to perform security
 checks on the device their code is running on
 */
public class AgsSec {
    
    public init(){}
    
    /**
     - Perform a security check on a device.
     
     - Parameter check: The security check to be performed
     - Returns: A SecurityCheckResult with a true or false property 'passed'
     */
    public func check(_ check: SecurityCheck) -> SecurityCheckResult{
        return check.check()
    }

    /**
     - Perform multiple security checks on a device
     
     - Parameter checks: The security checks to be performed
     - Returns: An array of type SecurityCheckResult with a true or false property 'passed' for each result
     */
    public func checkMany(_ checks: [SecurityCheck]) -> [SecurityCheckResult] {
        var completedChecks: [SecurityCheckResult] = [];
        for value in checks {
            completedChecks.append(check(value));
        };
        return completedChecks;
    }

}
