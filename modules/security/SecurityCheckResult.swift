import Foundation

public struct SecurityCheckResult {

    let name: String
    let passed: Bool

    init(_ name: String, _ passed: Bool) {
        self.name = name;
        self.passed = passed;
    }
}
