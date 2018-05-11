import Foundation

protocol SecurityCheck {

    var name: String { get set }

    func check() -> SecurityCheckResult

}
