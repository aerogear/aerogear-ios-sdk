import DTTJailbreakDetection
import Foundation

/**
 IsJailbrokenCheck implements the `SecurityCheck` protocol
 
 It can check whether or not the device the check is running on is a Jailbroken device.
 */
 public class NonJailbrokenCheck: SecurityCheck {
    public let name = "Jailbreak check"

    public init() {}

    /**
     - Check if the device is Jailbroken.

     - Returns: A Security Check result with a true or false passing property
     */
    public func check() -> SecurityCheckResult {
        if DTTJailbreakDetection.isJailbroken() {
            return SecurityCheckResult(self.name, false)
        } else {
            return SecurityCheckResult(self.name, true)
        }
    }
}
