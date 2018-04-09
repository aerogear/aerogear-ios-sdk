//
//  OIDCAuthenticator.swift
//  AGSAuth

import AGSCore
import AppAuth
import Foundation

/** Represents `openid` authentication actions like logout and login. */
public class OIDCAuthenticator: Authenticator {
    /** http instance used to make network requests */
    let http: AgsHttpRequestProtocol
    /** Keycloak configuration */
    let keycloakConfig: KeycloakConfig
    /** authentication configuration */
    let authConfig: AuthenticationConfig
    /** interface for persisting, loading and removing user credentials */
    let credentialManager: CredentialManagerProtocol

    /**  represents the `openid` authorisation flow used during login.
         The flow used is code flow.
     */
    var currentAuthorisationFlow: OIDAuthorizationFlowSession?

    /**
     Initialises the `openid` authenticator.

     - parameters:
        - http: http instance used to make network requests
        - keycloakConfig: Keycloak configuration used to perform login and logout against the server defined in the config
    */
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
        - onCompleted: a block function that will be invoked when the login is completed
        - user: the user returned in the `onCompleted` callback function.  Will be nil if authentication failed
        - error: the error returned in the `onCompleted` callback function. Will be nil if authentication was successful
     */
    public func authenticate(presentingViewController: UIViewController, onCompleted: @escaping (_ user: User?, _ error: Error?) -> Void) {
        let oidServiceConfiguration = OIDServiceConfiguration(authorizationEndpoint: self.keycloakConfig.authenticationEndpoint, tokenEndpoint: self.keycloakConfig.tokenEndpoint)
        let oidAuthRequest = OIDAuthorizationRequest(configuration: oidServiceConfiguration,
                                                     clientId: self.keycloakConfig.clientID,
                                                     scopes: [OIDScopeOpenID, OIDScopeProfile],
                                                     redirectURL: authConfig.redirectURL,
                                                     responseType: OIDResponseTypeCode,
                                                     additionalParameters: nil)

        //this will automatically exchange the token to get the user info
        self.currentAuthorisationFlow = startAuthorizationFlow(byPresenting: oidAuthRequest, presenting: presentingViewController) {
            oidcCredentials, error in

            guard let credentials = oidcCredentials else {
                return self.authFailure(error: error, onCompleted: onCompleted)
            }

            return self.authSuccess(credentials: credentials, onCompleted: onCompleted)
        }
    }

    /**
     Sends a request to the Keycloak server to perform token exchange.

     On successfully completing the token exchange the callback is invoked with the `openid` credentials for the user.
     Otherwise the callback is invoked with the error that occured during token exchange.

     - parameters:
        - byPresenting: an `openid` authorisation request
        - presenting: The view controller from which to present the SafariViewController
        - callback: a block function that will be invoked when the token exchange is completed
        - credentials: the `openid` credentials returned in the `callback` function.  Will be nil if the user is unauthorized
        - error: the error returned in the `callback` function.  Will be nil if the token exchange was successful
     */
    func startAuthorizationFlow(byPresenting: OIDAuthorizationRequest, presenting: UIViewController, callback: @escaping (_ credentials: OIDCCredentials?, _ error: Error?) -> Void) -> OIDAuthorizationFlowSession {
        return OIDAuthState.authState(byPresenting: byPresenting, presenting: presenting, callback: { authState, error in
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

    /**
     Invoked when a user has been successfully authenticated.

     This function saves the users credentials and returns a `User` object in the callback.

     - parameters:
        - credentials: `openid` credentials of the user that has been authenticated
        - onCompleted: a block function invoked containing a `User` object
        - user: the user returned in the `onCompleted` callback function
        - error: nil
     */
    func authSuccess(credentials: OIDCCredentials, onCompleted: @escaping (_ user: User?, _ error: Error?) -> Void) {
        credentialManager.save(credentials: credentials)
        onCompleted(User(credential: credentials, clientName: self.keycloakConfig.clientID), nil)
    }

    /**
     Invoked when a user authentication fails.

     This function removes the stored credentials and returns the error that occured during the authentication process

     - parameters:
        - error: the error that occured during the authentication process
        - onCompleted: a block function invoked containing the error
        - user: nil
        - error: the authentication error returned in the `onCompleted` callback function
     */
    func authFailure(error: Error?, onCompleted: @escaping (_ user: User?, _ error: Error?) -> Void) {
        credentialManager.clear()
        onCompleted(nil, error)
    }

    /**
     Resumes the authentication process. This function should be called when a user has finished logging in via the browser and is redirected back to the app that started the login.

     - parameters:
        - url: The redirect url passed backed from the login process

     - returns: true if the authentication can be resumed, false otherwise
     */
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
        - error: the error returned in the `onCompleted` callback function. The error will be a `noIdentityTokenError` if there is no identity token for the current user, a network error if there was a network failure.  If no error occured the error will be nil.
     */
    public func logout(currentUser: User, onCompleted: @escaping (_ error: Error?) -> Void) {
        guard let identityToken = currentUser.identityToken else {
            return onCompleted(AgsAuth.Errors.noIdentityTokenError)
        }
        let logoutURL = keycloakConfig.buildLogoutURL(idToken: identityToken)
        http.get(logoutURL, params: nil, headers: nil, { (response) -> Void in
            if let err = response.error {
                AgsCore.logger.error("Failed to perform logout operation due to error \(err.localizedDescription)")
                onCompleted(err)
            } else {
                self.credentialManager.clear()
                onCompleted(nil)
            }
        })
    }
}
