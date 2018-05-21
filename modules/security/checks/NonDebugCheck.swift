import Foundation

/**
 IsDebuggerCheck implements the `SecurityCheck` protocol
 
 It can check whether or not the device the check is running on is running with debug mode enabled
 */
public class NonDebugCheck: SecurityCheck {
    public var name = "Debugger"
    private let passing = "Debugger not detected"
    private let failing = "Debugger detected"

    public init() {}

    /**
     - Check if the device is running in Debug mode.

     - Returns: A Security Check result with a true or false passing property
     */
    public func check() -> SecurityCheckResult {
        #if DEBUG
            return SecurityCheckResult(self.name, false, self.failing)
        #else
            return SecurityCheckResult(self.name, true, self.passing)
        #endif
    }
}
