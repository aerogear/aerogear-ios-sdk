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
    var authState: OIDAuthState?
    var identity: User?
    
    init(http: AgsHttpRequestProtocol, keycloakConfig: KeycloakConfig, authConfig: AuthenticationConfig, credentialManager: CredentialManagerProtocol) {
        self.http = http
        self.keycloakConfig = keycloakConfig
        self.authConfig = authConfig
        self.credentialManager = credentialManager
    }

    public func authenticate(presentingViewController: UIViewController, onCompleted: @escaping (User?, Error?) -> Void) {
        //Add implementation
    }

    func performAuthentication(presentingViewController viewController:UIViewController, onCompleted: @escaping (User?, Error?) -> Void) {
        self.onCompleted = onCompleted
        let oidServiceConfiguration = OIDServiceConfiguration(authorizationEndpoint: self.keycloakConfig.authenticationEndpoint!, tokenEndpoint: self.keycloakConfig.tokenEndPoint!)
        let oidAuthRequest = OIDAuthorizationRequest(configuration: oidServiceConfiguration, clientId: self.keycloakConfig.clientId!, scopes: [OIDScopeOpenID, OIDScopeProfile], redirectURL: authConfig.redirectURL, responseType: OIDResponseTypeCode, additionalParameters: nil)
        
        //this will automatically exchange the token to get the user info
        self.currentAuthorisationFlow = OIDAuthState.authState(byPresenting: oidAuthRequest, presenting: viewController) {
            authState,error in
            if authState != nil && authState?.authorizationError == nil {
                self.authSuccess(authState: authState!)
            } else {
                self.authFailure(authState: authState, error: error)
            }
        }
    }
    
    fileprivate func assignAuthState(authState: OIDAuthState?) {
        self.authState = authState
        self.identity = self.getIdentity(authState: authState)
        self.saveState()
    }
    
    fileprivate func saveState() {
        // TODO: implement
    }
    
    fileprivate func getIdentity(authState: OIDAuthState?) -> User? {
        if authState == nil {
            return nil
        }
        return User(accessToken: authState!.lastTokenResponse?.accessToken)
    }
    
    func authSuccess(authState: OIDAuthState) {
        self.assignAuthState(authState: authState)
        self.authCompleted(identity: self.identity, error: nil)
    }
    
    func authFailure(authState: OIDAuthState?, error: Error?) {
        let e = authState?.authorizationError ?? error
        self.assignAuthState(authState: nil)
        self.authCompleted(identity: nil, error: e)
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
        return false
    }

}

func base64urlToBase64(base64url: String) -> String {
    var base64 = base64url
    .replacingOccurrences(of: "-", with: "+")
    .replacingOccurrences(of: "_", with: "/")
    if base64.characters.count % 4 != 0 {
        base64.append(String(repeating: "=", count: 4 - base64.characters.count % 4))
    }
    return base64
}

extension User {
    init?(accessToken: String!) {
        if accessToken == nil {
            return nil
        }
        let parts = accessToken?.components(separatedBy: ".")
        guard let encodedToken = parts?[1] else {
            return nil
        }
        guard let jsonData = Data(base64Encoded: base64urlToBase64(base64url: encodedToken)) else {
            return nil
        }
        let tokenJson = try? JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: Any]
        guard let userName = tokenJson!["name"] as? String,
        let emailAddress = tokenJson!["email"] as? String,
        let realmAccess = tokenJson!["realm_access"] as? [String: [String]],
        let realmRoles = realmAccess["roles"]
        else {
            return nil
        }
        self.userName = userName
        self.accessToken = accessToken
        self.email = emailAddress
        // TODO: set identity token
        self.identityToken = ""
        
        // TODO: parse roles
        self.roles = []
    }
}
