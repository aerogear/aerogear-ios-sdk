import Foundation

/**
 IsEmulatorCheck implements the `SecurityCheck` protocol

 It can check whether or not the device the check is running on is running within an emulator or not.
 */
public class NonEmulatorCheck: SecurityCheck {
    public let name = "Emulator check"

    public init() {}

    /**
     - Check if the device is running in an emulator.

     - Returns: A Security Check result with a true or false passing property
     */
    public func check() -> SecurityCheckResult {
        var passed = true
        #if (arch(i386) || arch(x86_64) && os(iOS))
            passed = false
        #endif
        return SecurityCheckResult(self.name, passed)
    }
}
