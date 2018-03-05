//
//  AuthConfig.swift
//  AGSAuth
import AGSCore
import Foundation

/** All the configurations related to Keycloak */
class KeycloakConfig {
    private let sdkId = "keycloak"
    
    private let serverUrlName = "auth-server-url"
    private let realmIdName = "realm"
    private let clientIdName = "resource"
    
    private let tokenHintFragment = "id_token_hint"
    private let redirectFragment = "redirect_uri"
    
    private let baseUrlTemplate = "%@/realms/%@/protocol/openid-connect"
    private let logoutUrlTemplate = "%@/logout?%@=%@&%@=%@"
    
    private var serverUrl: String = ""
    private var realmId: String = ""
    private var clientId: String = ""
    private var baseUrl: String = ""
    
    public var rawConfig: MobileService?
    
    init(_ configService: ServiceConfig) {
        if let serviceConfig = configService[sdkId] {
            rawConfig = serviceConfig
            serverUrl = (serviceConfig.config![serverUrlName]?.getString())!
            realmId = (serviceConfig.config![realmIdName]?.getString())!
            clientId = (serviceConfig.config![clientIdName]?.getString())!
            baseUrl = String(format: baseUrlTemplate, serverUrl, realmId)
        } else {
            AgsCore.logger.error("""
                Mobile configuration is missing auth service.
                Auth will not be enabled
                Please review sdk configuration file.
            """)
        }
    }
    
    // Get the URL for the Keycloak authentication endpoint
    var authenticationEndpoint: URL {
        get {
            return URL(string: "\(baseUrl)/auth")!
        }
    }
    
    // Get the URL for the token exchange endpoint
    var tokenEndpoint: URL {
        get {
            return URL(string: "\(baseUrl)/token")!
        }
    }
    
    // Get the client id string
    var clientID: String {
        get {
            return clientId
        }
    }
    
    // Get the logout URL string
    public func getLogoutUrl(idToken: String, redirectUri: URL) -> String {
        return String(format: logoutUrlTemplate, baseUrl, tokenHintFragment, idToken, redirectFragment, redirectUri.absoluteString)
    }
    
    // Get the URL string of the Keycloak service
    var hostUrl: String {
        get {
            return serverUrl
        }
    }
    
    // Get the realm name of the Keycloak service
    var realmName: String {
        get {
            return realmId
        }
    }
    
    // Get the URL where JWKs can be retrieved
    var jwksUrl: String {
        get {
            return "\(baseUrl)/certs"
        }
    }
    
    // Get the JWK Issuer
    var issuer: String {
        get {
            return String(format: "%@/realms/%@", hostUrl, realmName)
        }
    }
    
}
