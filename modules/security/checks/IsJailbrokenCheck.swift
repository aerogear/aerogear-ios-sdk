import Foundation
import DTTJailbreakDetection

public class IsJailbrokenCheck: SecurityCheck {
    public let name = "Jailbreak"

    public init(){}
    
    /**
     - Check if the device is Jailbroken.
     
     - Returns: A Security Check result with a true or false passing property
     */
    public  func check() -> SecurityCheckResult {
        if (DTTJailbreakDetection.isJailbroken()) {
            return SecurityCheckResult(self.name, false)
        } else {
            return SecurityCheckResult(self.name, true)
        }
    }
}
