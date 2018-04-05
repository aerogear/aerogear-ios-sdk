//
//  OIDCCredentials
//  AGSAuth

import AppAuth
import Foundation

/**
 A class to represent the OpenID Connect state for an entity.
 This is backed by a standard OIDC token.
 */
public class OIDCCredentials: NSObject, NSCoding {
    /** key used to identify the auth state */
    static let authStateEncodingKey = "authState"
    /** the authentication state */
    let authState: OIDAuthState

    /** Access token of the credential. Will be nil if not authorized. */
    var accessToken: String? {
        return authState.lastTokenResponse?.accessToken
    }

    /** Identity token of the credential. Will be nil if not authorized. */
    var identityToken: String? {
        return authState.lastTokenResponse?.idToken
    }

    /** Refresh token of the credential. Will be nil if not authorized. */
    var refreshToken: String? {
        return authState.lastTokenResponse?.refreshToken
    }

    /** Whether the credential is currently authorized. */
    var isAuthorized: Bool {
        return authState.isAuthorized
    }

    /** Whether the token backing the credential is expired. Will be nil if not authorized. */
    var isExpired: Bool {
        return (authState.lastTokenResponse?.accessTokenExpirationDate)! < Date()
    }

    /**
     Initialises the `openid` credentials.

     - parameters:
        - state: the authentication state that monitors authorisation and token requests/responses
     */
    public init(state: OIDAuthState) {
        authState = state
    }

    public required init?(coder aDecoder: NSCoder) {
        authState = aDecoder.decodeObject(forKey: OIDCCredentials.authStateEncodingKey) as! OIDAuthState
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(authState, forKey: OIDCCredentials.authStateEncodingKey)
    }
}
