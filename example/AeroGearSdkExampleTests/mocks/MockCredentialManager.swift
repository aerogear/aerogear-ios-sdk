import AGSAuth
import AppAuth
import Foundation

class MockCredentialManager: CredentialManagerProtocol {
    var loadCalled = false
    var saveCalled = false
    var clearCalled = false

    func load() -> OIDCCredentials? {
        loadCalled = true
        return nil
    }

    func save(credentials _: OIDCCredentials) {
        saveCalled = true
    }

    func clear() {
        clearCalled = true
    }
}
