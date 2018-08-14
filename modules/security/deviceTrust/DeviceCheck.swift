import Foundation

/**
 SecurityCheck protocol to define the individual security checks

 */
public protocol DeviceCheck {

    /**
     The name of the Security Check
    */
    var name: String { get }

    /**
     Performs a security check and returns a security check result
    */
    func check() -> DeviceCheckResult
}
