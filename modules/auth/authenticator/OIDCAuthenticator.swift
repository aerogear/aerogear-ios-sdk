//
//  OIDCAuthenticator.swift
//  AGSAuth

import Foundation
import AGSCore

public class OIDCAuthenticator: Authenticator {

    let http: AgsHttpRequestProtocol
    let keycloakConfig: KeycloakConfig
    let authConfig: AuthenticationConfig
    let credentialManager: CredentialManagerProtocol

    init(http: AgsHttpRequestProtocol, keycloakConfig: KeycloakConfig, authConfig: AuthenticationConfig, credentialManager: CredentialManagerProtocol) {
        self.http = http
        self.keycloakConfig = keycloakConfig
        self.authConfig = authConfig
        self.credentialManager = credentialManager
    }

    public func authenticate(presentingViewController: UIViewController, onCompleted: @escaping (User?, Error?) -> Void) {
        //Add implementation
    }

    public func logout(currentUser: User, onCompleted: @escaping (Error?) -> Void) {
        let logoutUrl = keycloakConfig.getLogoutUrl(idToken: currentUser.identityToken)
        http.get(logoutUrl, params: nil, headers: nil, { (response, error) -> Void in
            if let err = error {
                AgsCore.logger.error("Failed to perform logout operation due to error \(err.localizedDescription)")
                onCompleted(err)
            } else {
                self.credentialManager.clear()
                onCompleted(nil)
            }
        })
    }
}
