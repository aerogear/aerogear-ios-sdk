import DTTJailbreakDetection
import Foundation

public class NonJailbrokenCheck: SecurityCheck {
    public let name = "Jailbreak"
    private let passing = "Jailbreak not detected"
    private let failing = "Jailbreak detected"

    public init() {}

    /**
     - Check if the device is Jailbroken.

     - Returns: A Security Check result with a true or false passing property
     */
    public func check() -> SecurityCheckResult {
        if DTTJailbreakDetection.isJailbroken() {
            return SecurityCheckResult(self.name, false, self.failing)
        } else {
            return SecurityCheckResult(self.name, true, self.passing)
        }
    }
}
