import Foundation

public class IsDebuggerCheck: SecurityCheck {
    public var name = "Debugger"
  
    public init(){}
    
    /**
     - Check if the device is running in Debug mode.
     
     - Returns: A Security Check result with a true or false passing property
     */
    public func check() -> SecurityCheckResult {
        #if DEBUG
        return SecurityCheckResult(self.name, false)
        #else
        return SecurityCheckResult(self.name, true)
        #endif
    }
}
