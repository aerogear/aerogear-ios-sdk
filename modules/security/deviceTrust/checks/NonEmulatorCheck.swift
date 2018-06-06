import Foundation

/**
 IsEmulatorCheck implements the `SecurityCheck` protocol
 
 It can check whether or not the device the check is running on is running within an emulator or not.
 */
 public class NonEmulatorCheck: SecurityCheck {
    public let name = "Emulator check"
    private let passing = "Emulator not detected"
    private let failing = "Emulator detected"

    public init() {}

    /**
     - Check if the device is running in an emulator.

     - Returns: A Security Check result with a true or false passing property
     */
    public func check() -> SecurityCheckResult {
        #if (arch(i386) || arch(x86_64) && os(iOS))
            return SecurityCheckResult(self.name, false, self.failing)
        #endif
        return SecurityCheckResult(self.name, true, self.passing)
    }
}
