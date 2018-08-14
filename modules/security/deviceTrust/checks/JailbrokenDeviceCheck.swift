import DTTJailbreakDetection
import Foundation

/**
 IsJailbrokenCheck implements the `DeviceCheck` protocol

 It can check whether or not the device the check is running on is a Jailbroken device.
 */
public class JailbrokenDeviceCheck: DeviceCheck {
    public let name = "Jailbreak check"

    public init() {}

    /**
     - Check if the device is Jailbroken.

     - Returns: A Device Check result with a true or false passing property
     */
    public func check() -> DeviceCheckResult {
        return DeviceCheckResult(self.name, DTTJailbreakDetection.isJailbroken())
    }
}
