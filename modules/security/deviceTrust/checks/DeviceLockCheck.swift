import Foundation
import LocalAuthentication

/**
 IsDeviceLockCheck implements the `SecurityCheck` protocol
 
 It can check whether or not the device the check is running on has a device lock enabled
 */
 public class DeviceLockCheck: SecurityCheck {
    public let name = "Device Lock check"

    public init() {}

    /**
     - Check if a lock screen is set on the device.

     - Returns: A Security Check result with a true or false passing property
     */
    public func check() -> SecurityCheckResult {
        let deviceLockSet = LAContext().canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
        return SecurityCheckResult(self.name, deviceLockSet)
    }
}
