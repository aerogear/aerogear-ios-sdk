import Foundation

public class IsEmulatorCheck: SecurityCheck {
    var name = "Is Emulator Check"
    
    internal func check() -> SecurityCheckResult {
        #if (arch(i386) || arch(x86_64) && os(iOS))
        return SecurityCheckResult(self.name, false)
        #endif
        return SecurityCheckResult(self.name, true)
    }
}
