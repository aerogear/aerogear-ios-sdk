//
//  OIDCCredentials
//  AGSAuth

import AppAuth
import Foundation

/// A class to represent the OpenID Connect state for an entity.
/// This is backed by a standard OIDC token.
public class OIDCCredentials {
    let authState: OIDAuthState

    public init(state: OIDAuthState) {
        authState = state
    }

    /**
     Get the access token for the credential.
 
     - Returns: An access token.
    */
    public func getAccessToken() -> String? {
        return authState.lastTokenResponse?.accessToken
    }

    /**
     Get the identity token for the credential.

     - Returns: An identity token.
    */
    public func getIdentitityToken() -> String? {
        return authState.lastTokenResponse?.idToken
    }

    /**
     Get the refresh token for the credential.

     - Returns: A refresh token.
    */
    public func getRefreshToken() -> String? {
        return authState.lastTokenResponse?.refreshToken
    }

    /**
     Check whether the token is expired. This is based on the expires_in value of the token response.

     - Returns: true if the token is expired.
    */
    public func isExpired() -> Bool {
        return (authState.lastTokenResponse?.accessTokenExpirationDate)! < Date()
    }

    /**
     If the credential is in an authorized state.
 
     - Returns: true if the credential is authorized.
    */
    public func isAuthorized() -> Bool {
        return authState.isAuthorized
    }
}
