import Foundation

/**
 AeroGear Services Security SDK
 
 SDK provides a way for the developer to perform security
 checks on the device their code is running on
 */
public class AgsSec {

    func check(_ check: SecurityCheck) -> SecurityCheckResult{
        return check.check()
    }

    func checkMany(checks: [SecurityCheck]) -> [SecurityCheckResult] {
        var completedChecks: [SecurityCheckResult] = [];
        for value in checks {
            completedChecks.append(check(value));
        };
        return completedChecks;
    }
}
