import AGSCore
import Foundation

/**
 AeroGear Auth Service
 */
open class AgsAuth {
    
    enum Errors: Error {
        case NoLoggedInUserError
    }
    
    let authenticator: Authenticator
    let credentialManager: CredentialsManager
    let keycloakConfig: KeycloakConfig
    let authServiceConfig: AuthenticationConfig

    init(serviceConfig: ServiceConfig, authConfig: AuthenticationConfig) {
        keycloakConfig = KeycloakConfig(serviceConfig, authConfig)
        authServiceConfig = authConfig
        credentialManager = CredentialsManager()
        authenticator = OIDCAuthenticator(http: AgsCore.instance.getHttp(), keycloakConfig: keycloakConfig, authConfig: authConfig, credentialManager: credentialManager)
    }

    public func login(presentingViewController: UIViewController, onCompleted: @escaping (User?, Error?) -> Void) {
        authenticator.authenticate(presentingViewController: presentingViewController, onCompleted: onCompleted)
    }

    public func resumeAuth(url: URL) -> Bool {
        return authenticator.resumeAuth(url: url)
    }

    public func logout(onCompleted: @escaping (Error?) -> Void) {
        if let currentUser = currentUser() {
            authenticator.logout(currentUser: currentUser, onCompleted: onCompleted)
        } else {
            onCompleted(Errors.NoLoggedInUserError)
        }
    }

    public func currentUser() -> User? {
        return nil
    }
}
