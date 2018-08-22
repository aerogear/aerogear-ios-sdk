import Foundation
import LocalAuthentication

/**
 IsDeviceLockCheck implements the `DeviceCheck` protocol

 It can check whether or not the device the check is running on has a device lock enabled
 */
public class DeviceLockEnabledCheck: DeviceCheck {
    public let name = "Device Lock check"

    public init() {}

    /**
     - Check if a lock screen is set on the device.

     - Returns: A Device Check result with a true or false passing property
     */
    public func check() -> DeviceCheckResult {
        let deviceLockSet = LAContext().canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
        return DeviceCheckResult(self.name, deviceLockSet)
    }
}
