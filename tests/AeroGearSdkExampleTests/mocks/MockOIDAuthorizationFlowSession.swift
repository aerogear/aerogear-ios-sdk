
import AppAuth
import Foundation

class MockOIDAuthorizationFlowSession: NSObject, OIDAuthorizationFlowSession {
    func cancel() {
    }

    func resumeAuthorizationFlow(with URL: URL) -> Bool {
        return false
    }

    func failAuthorizationFlowWithError(_ error: Error) {
    }
}
