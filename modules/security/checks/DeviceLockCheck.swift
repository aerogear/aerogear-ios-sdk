import Foundation
import LocalAuthentication

/**
 IsDeviceLockCheck implements the `SecurityCheck` protocol
 
 It can check whether or not the device the check is running on has a device lock enabled
 */
 public class DeviceLockCheck: SecurityCheck {
    public let name = "Device Lock"
    private let passing = "Device lock detected"
    private let failing = "Device lock not detected"

    public init() {}

    /**
     - Check if a lock screen is set on the device.

     - Returns: A Security Check result with a true or false passing property
     */
    public func check() -> SecurityCheckResult {
        let deviceLockSet = LAContext().canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
        if deviceLockSet == false {
            return SecurityCheckResult(self.name, false, self.failing)
        } else {
            return SecurityCheckResult(self.name, true, self.passing)
        }
    }
}
