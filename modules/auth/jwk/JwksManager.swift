//
//  JWKManager.swift
//  AGSAuth
//

import Foundation
import AGSCore
import SwiftKeychainWrapper

/**
  Manages JSON Web Key Set(JWKS)
 */
class JwksManager {
    
    let http: AgsHttpRequestProtocol
    let authConfig: AuthenticationConfig
    
    let keySuffixForJwks = "jwks_content"
    let keySuffixForRequestDate = "requested_date"
    
    /**
     Initialises the JWKS Manager
     
     - parameters:
        - http: shared http instance used to make network requests
        - authConfig: configuration for the authentication service
    */
    init(_ http: AgsHttpRequestProtocol, _ authConfig: AuthenticationConfig) {
        self.http = http
        self.authConfig = authConfig
    }
    
    /**
     Tries to get the cached JWKS first and if not found in the cahce will return nil.
     It will invoke the fetchJwksIfNeeded() function in the background.
     
     - parameters:
        - keycloakConfig: the keycloak service configuration used to load the JWKS
     - returns: cached JWKS or nil if it doesn't exist
    */
    public func load(_ keycloakConfig: KeycloakConfig) -> [String: Any]? {
        let namespace = keycloakConfig.realmName
        let jwksEntryName = buildEntryNameForJwksContent(namespace)
        if let jwksContent = KeychainWrapper.standard.string(forKey: jwksEntryName) {
            fetchJwksIfNeeded(keycloakConfig, false)
            let jwksData = jwksContent.data(using: .utf8)
            let jwks = try? JSONSerialization.jsonObject(with: jwksData!, options: .mutableLeaves)
            return jwks as? [String : Any]
        }
        fetchJwksIfNeeded(keycloakConfig, true)
        return nil
    }
    
    /**
     Fetches the JWKS from the server if forceFetch is set to true or checks should the JWKS
     be requested by comparing the getMinTimeBetweenJwksRequests (defined in authConfig
     used to initialise this JwksManager) to the last time the JWKS was requested.
     
     - parameters:
        - keycloakConfig: the keycloak service configuration used to get the keycloak server information
        - forceFetch: if set to true, requests JWKS from the server immediately
     - returns: true if the JWKS was fetched from the server, false otherwise
    */
    @discardableResult public func fetchJwksIfNeeded(_ keycloakConfig: KeycloakConfig, _ forceFetch: Bool) -> Bool {
        if (forceFetch || shouldRequestJwks(keycloakConfig)) {
            fetchJwks(keycloakConfig)
            return true
        }
        return false
    }
    
    /**
     Request JWKS from the Keycloak server and persists the JWKS locally.
     
     - parameters:
        - keycloakConfig: the keycloak service configuration that contains the keycloak server information to make requests to
        - onCompleted: callback function to ebe invoked when the request is complete. Defaults to nil
     
    */
    public func fetchJwks(_ keycloakConfig: KeycloakConfig, onCompleted: (([String: Any]?, Error?) -> Void)? = nil) {
        let jwksUrl = keycloakConfig.jwksUrl
        http.get(jwksUrl, params: nil, headers: nil, {(response, error) -> Void in
            if let error = error {
                if (onCompleted != nil) {
                    return onCompleted!(nil, error)
                }
                AgsCore.logger.error("Error fetching JWKS: \(error)")
            }
            else if let response = response as? [String: Any] {
                let resString = response.description
                self.persistJwks(keycloakConfig.realmName, resString)
                if (onCompleted != nil) {
                    return onCompleted!(response, nil)
                }
            }
        })
    }
    
    /**
     Determines whether the JWKS should be requested from the server by comparing the
     last time the JWKS was requested to the getMinTimeBetweenJwksRequests (defined in
     authConfig used to initialise this JwksManager).
     
     - parameters:
        - keycloakConfig: the configuration of the Keycloak server
     - returns: true if the request should be triggered, false otherwise
    */
    private func shouldRequestJwks(_ keycloakConfig: KeycloakConfig) -> Bool {
        let namespace = keycloakConfig.realmName
        let requestedDateEntryName = buildEntryNameForQuestedDate(namespace)

        if let lastRequestDateString = KeychainWrapper.standard.string(forKey: requestedDateEntryName) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
            let lastRequestDate = dateFormatter.date(from: lastRequestDateString)

            let duration = lastRequestDate?.timeIntervalSinceNow
            let durationInMinutes = duration!/60
            if (abs(durationInMinutes) < Double(authConfig.minTimeBetweenJwksRequests)) {
                return false
            }
        }
        return true
    }
    
    /**
     Save the JWKS content for the given realm name locally using [SwiftKeychainWrapper](https://github.com/jrendel/SwiftKeychainWrapper).
     
     - parameters:
        - keycloakRealmName: the realm associated with the JWKS
        - jwks: the content of the JWKS
    */
    private func persistJwks(_ keycloakRealmName: String, _ jwks: String) {
        let timeFetched = Date.init(timeIntervalSince1970: Date().timeIntervalSince1970).description
        KeychainWrapper.standard.set(jwks, forKey: buildEntryNameForJwksContent(keycloakRealmName))
        KeychainWrapper.standard.set(timeFetched, forKey: buildEntryNameForQuestedDate(keycloakRealmName))
    }
    
    /**
     Build the entry name for the JWKS content
     
     - parameters:
        - keycloakRealmName: the realm associated with the JWKS
     - returns: the full entry name
    */
    public func buildEntryNameForJwksContent(_ keycloakRealmName: String) -> String {
        return String(format: "%@_%@", keycloakRealmName, keySuffixForJwks)
    }
    
    /**
     Build the entry name for the last requested date for the JWKS content
     
     - parameters:
        - keycloakRealmName: the realm associated with the JWKS
     - returns: the full entry name
    */
    public func buildEntryNameForQuestedDate(_ keycloakRealmName: String) -> String {
        return String(format: "%@_%@", keycloakRealmName, keySuffixForRequestDate)
    }
}
