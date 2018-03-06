//
//  OIDCAuthenticator.swift
//  AGSAuth

import AGSCore
import Foundation

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

    public func authenticate(presentingViewController _: UIViewController, onCompleted _: @escaping (User?, Error?) -> Void) {
        // Add implementation
    }

    /**
     Perform the logout operation. It will send a HTTP request to the server to invalidate the session for the user.
     If the request is successful, it will remove the local credential data automatically and invoke the onCompleted function.
     Otherwise it will invoke the onCompleted callback with an error.
     
     - parameters:
       - currentUser: the user that should be logged out
       - onCompleted: a block function that will be invoked when the logout is completed.
     */
    public func logout(currentUser: User, onCompleted: @escaping (Error?) -> Void) {
        let logoutURL = keycloakConfig.buildLogoutURL(idToken: currentUser.identityToken)
        http.get(logoutURL, params: nil, headers: nil, { (_, error) -> Void in
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
