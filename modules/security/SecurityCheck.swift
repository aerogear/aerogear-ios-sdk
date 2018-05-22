import Foundation

public protocol SecurityCheck {
    var name: String { get }

    func check() -> SecurityCheckResult
}
