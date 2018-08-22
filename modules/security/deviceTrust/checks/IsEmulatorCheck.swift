import Foundation

/**
 IsEmulatorCheck implements the `DeviceCheck` protocol

 It can check whether or not the device the check is running on is running within an emulator or not.
 */
public class IsEmulatorCheck: DeviceCheck {
    public let name = "Emulator check"

    public init() {}

    /**
     - Check if the device is running in an emulator.

     - Returns: A Device Check result with a true or false passing property
     */
    public func check() -> DeviceCheckResult {
        var passed = false
        #if (arch(i386) || arch(x86_64) && os(iOS))
            passed = true
        #endif
        return DeviceCheckResult(self.name, passed)
    }
}
