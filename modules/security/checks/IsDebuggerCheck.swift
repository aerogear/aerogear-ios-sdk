import Foundation

public class IsDebuggerCheck: SecurityCheck {
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
