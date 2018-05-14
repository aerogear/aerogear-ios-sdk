import Foundation

public struct SecurityCheckResult {

    public let name: String
    public let passed: Bool

    init(_ name: String, _ passed: Bool) {
        self.name = name;
        self.passed = passed;
    }
}
