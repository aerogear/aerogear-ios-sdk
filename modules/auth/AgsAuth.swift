import Foundation
import AGSCore

/**
 * AeroGear Auth Service
 */
open class AgsAuth {
    let authenticator: Authenticator
    let credentialManager: CredentialsManager
    let keycloakConfig: KeycloakConfig
    let authServiceConfig: AuthenticationConfig

    init(serviceConfig: ServiceConfig, authConfig: AuthenticationConfig) {
        keycloakConfig = KeycloakConfig(serviceConfig)
        authServiceConfig = authConfig
        credentialManager = CredentialsManager()
        authenticator = OIDCAuthenticator()
    }

    public func login(presentingViewController: UIViewController, onCompleted: @escaping (User?, Error?) -> Void) {

    }

    public func resumeAuth(url: URL) -> Bool {
        return false
    }

    public func logout(onCompleted: @escaping (Error?) -> Void) {

    }

    public func currentUser() -> User? {
        return nil
    }
}
