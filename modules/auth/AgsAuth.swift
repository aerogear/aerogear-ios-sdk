import AGSCore
import Foundation

/**
 AeroGear Auth Service
 */
open class AgsAuth {
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

    public func login(presentingViewController _: UIViewController, onCompleted _: @escaping (User?, Error?) -> Void) {
    }

    public func resumeAuth(url _: URL) -> Bool {
        return false
    }

    public func logout(onCompleted _: @escaping (Error?) -> Void) {
    }

    public func currentUser() -> User? {
        return nil
    }
}
