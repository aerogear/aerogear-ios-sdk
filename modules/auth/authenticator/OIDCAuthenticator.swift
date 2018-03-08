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

    var onCompleted: ((User?, Error?) -> Void)?
    var currentAuthorisationFlow: OIDAuthorizationFlowSession?
    
    init(http: AgsHttpRequestProtocol, keycloakConfig: KeycloakConfig, authConfig: AuthenticationConfig, credentialManager: CredentialManagerProtocol) {
        self.http = http
        self.keycloakConfig = keycloakConfig
        self.authConfig = authConfig
        self.credentialManager = credentialManager
    }

    public func authenticate(presentingViewController: UIViewController, onCompleted: @escaping (User?, Error?) -> Void) {
        self.onCompleted = onCompleted
        let oidServiceConfiguration = OIDServiceConfiguration(authorizationEndpoint: self.keycloakConfig.authenticationEndpoint, tokenEndpoint: self.keycloakConfig.tokenEndpoint)
        let oidAuthRequest = OIDAuthorizationRequest(configuration: oidServiceConfiguration, clientId: self.keycloakConfig.clientID, scopes: [OIDScopeOpenID, OIDScopeProfile], redirectURL: authConfig.redirectURL, responseType: OIDResponseTypeCode, additionalParameters: nil)
        
        //this will automatically exchange the token to get the user info
        self.currentAuthorisationFlow = OIDAuthState.authState(byPresenting: oidAuthRequest, presenting: presentingViewController) {
            authState,error in
            
            if let state = authState {
                if let err = state.authorizationError {
                    self.authFailure(authState: state, error: err)
                } else {
                    self.authSuccess(authState: state)
                }
            } else {
                self.authFailure(error: error)
            }
        }
    }
    
    fileprivate func getIdentity(authState: OIDAuthState?) -> User? {
        if let state = authState {
            let credentials = OIDCCredentials(state: state)
            return User(credential: credentials, clientName: self.keycloakConfig.clientID)
        }
        
        return nil
    }
    
    func authSuccess(authState: OIDAuthState) {
        let credentials = OIDCCredentials(state: authState)
        credentialManager.save(credentials: credentials)
        self.authCompleted(identity: self.getIdentity(authState: authState), error: nil)
    }
    
    func authFailure(authState: OIDAuthState? = nil, error: Error?) {
        credentialManager.clear()
        self.authCompleted(identity: nil, error: error)
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
    
    func authCompleted(identity: User?, error: Error?) {
        if (self.onCompleted != nil) {
            self.onCompleted!(identity, error)
        }
    }
    
    public func resumeAuth(url: URL) -> Bool {
        if self.currentAuthorisationFlow!.resumeAuthorizationFlow(with: url) {
            self.currentAuthorisationFlow = nil;
            return true
        }
        return false
    }

}
