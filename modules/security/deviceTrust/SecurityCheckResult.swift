import Foundation

/**
 Structure to define each check result
 
 A successful check means that the environment the application is running in is more secure and no action is required, as opposed to signalling if a certain feature is enabled.
 */
public struct SecurityCheckResult: Encodable {
    
    public let name: String
    public let passed: Bool
    public var result: String

    /**
     - Initialise a SecurityCheckResult
     
     - Parameter name: the name of the check result
     - Parameter passed: whether or not the security check passed or failed
     - Parameter result: a description of the result
     */
    public init(_ name: String, _ passed: Bool, _ result: String) {
        self.name = name
        self.passed = passed
        self.result = result
    }
}
