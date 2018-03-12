//
//  OIDCAuthenticator.swift
//  AGSAuth

import Foundation
import AGSCore
import AppAuth

public class OIDCAuthenticator: Authenticator {
    
    let http: AgsHttpRequestProtocol
    let keycloakConfig: KeycloakConfig
    let authConfig: AuthenticationConfig
    let credentialManager: CredentialManagerProtocol
    
    var currentAuthorisationFlow: OIDAuthorizationFlowSession?
    
    init(http: AgsHttpRequestProtocol, keycloakConfig: KeycloakConfig, authConfig: AuthenticationConfig, credentialManager: CredentialManagerProtocol) {
        self.http = http
        self.keycloakConfig = keycloakConfig
        self.authConfig = authConfig
        self.credentialManager = credentialManager
    }
    
    /**
     Perform the logoin operation. It will open a browser to the configured login url.
     If the login is successful, it will save the credential data automatically and invoke the onCompleted function with the logged in user.
     Otherwise it will invoke the onCompleted callback with an error.
     
     - parameters:
     - presentingViewController: The view controller from which to present the SafariViewController
     - onCompleted: a block function that will be invoked when the login is completed.
     */
    public func authenticate(presentingViewController: UIViewController, onCompleted: @escaping (User?, Error?) -> Void) {
        let oidServiceConfiguration = OIDServiceConfiguration(authorizationEndpoint: self.keycloakConfig.authenticationEndpoint, tokenEndpoint: self.keycloakConfig.tokenEndpoint)
        let oidAuthRequest = OIDAuthorizationRequest(configuration: oidServiceConfiguration,
                                                     clientId: self.keycloakConfig.clientID,
                                                     scopes: [OIDScopeOpenID, OIDScopeProfile],
                                                     redirectURL: authConfig.redirectURL,
                                                     responseType: OIDResponseTypeCode,
                                                     additionalParameters: nil)
        
        //this will automatically exchange the token to get the user info
        self.currentAuthorisationFlow = startAuthorizationFlow(byPresenting: oidAuthRequest, presenting: presentingViewController) {
            oidcCredentials,error in
            
            guard let credentials = oidcCredentials else  {
                return self.authFailure(error: error, onCompleted: onCompleted)
            }
            
            return self.authSuccess(credentials: credentials, onCompleted: onCompleted)
        }
    }
    
    func startAuthorizationFlow(byPresenting: OIDAuthorizationRequest, presenting: UIViewController, callback: @escaping (OIDCCredentials?, Error?) -> Void) -> OIDAuthorizationFlowSession {
        return OIDAuthState.authState(byPresenting: byPresenting, presenting: presenting, callback: {authState, error  in
            if let state = authState {
                if let err = state.authorizationError {
                    callback(nil, err)
                } else {
                    callback(OIDCCredentials(state: authState!), nil)
                }
            } else {
                callback(nil, error)
            }
        })
    }
    
    func authSuccess(credentials: OIDCCredentials, onCompleted: @escaping (User?, Error?) -> Void) {
        credentialManager.save(credentials: credentials)
        onCompleted(User(credential: credentials, clientName: self.keycloakConfig.clientID), nil)
    }
    
    func authFailure(error: Error?, onCompleted: @escaping (User?, Error?) -> Void) {
        credentialManager.clear()
        onCompleted(nil, error)
    }
    
    public func resumeAuth(url: URL) -> Bool {
        guard let flow = self.currentAuthorisationFlow else {
            return false
        }
        if flow.resumeAuthorizationFlow(with: url) {
            self.currentAuthorisationFlow = nil
            return true
        }
        return false
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
        guard let identityToken = currentUser.identityToken else {
            return onCompleted(AgsAuth.Errors.noIdentityTokenError)
        }
        let logoutURL = keycloakConfig.buildLogoutURL(idToken: identityToken)
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

