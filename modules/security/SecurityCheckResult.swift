import Foundation

public struct SecurityCheckResult {
    public let name: String
    public let passed: Bool
    public var result: String

    public init(_ name: String, _ passed: Bool, _ result: String) {
        self.name = name
        self.passed = passed
        self.result = result
    }
}
