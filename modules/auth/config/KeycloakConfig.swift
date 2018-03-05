//
//  AuthConfig.swift
//  AGSAuth
import AGSCore
import Foundation

/** All the configurations related to Keycloak */
class KeycloakConfig {
    private let sdkId = "keycloak"
    
    private let SERVER_URL_NAME = "auth-server-url"
    private let REALM_ID_NAME = "realm"
    private let CLIENT_ID_NAME = "resource"
    
    private let TOKEN_HINT_FRAGMENT = "id_token_hint"
    private let REDIRECT_FRAGMENT = "redirect_uri"
    
    private let BASE_URL_TEMPLATE = "%@/realms/%@/protocol/openid-connect"
    private let LOGOUT_URL_TEMPLATE = "%@/logout?%@=%@&%@=%@"
    
    private var serverUrl: String = ""
    private var realmId: String = ""
    private var clientId: String = ""
    private var baseUrl: String = ""
    private var otherBaseUrl: String = ""
    
    public var rawConfig: MobileService?
    
    init(_ configService: ServiceConfig) {
        if let serviceConfig = configService[sdkId] {
            rawConfig = serviceConfig
            // this needs to be updated to be something like: serverUrl = serviceConfig.config[SERVER_URL_NAME]
            // must refactor the ConfigType enum
            
            serverUrl = "https://keycloak-myproject.192.168.64.74.nip.io/auth"
            realmId = "myproject"
            clientId = "juYAlRlhTyYYmOyszFa"
            baseUrl = String(format: BASE_URL_TEMPLATE, serverUrl, realmId)
        } else {
            AgsCore.logger.error("""
                Mobile configuration is missing auth service.
                Auth will not be enabled
                Please review sdk configuration file.
            """)
        }
    }
    
    // Get the URL for the Keycloak authentication endpoint
    public func getAuthenticationEndpoint() -> URL {
        return URL(string: "\(baseUrl)/auth")!
    }
    
    // Get the URL for the token exchange endpoint
    public func getTokenEndpoint() -> URL {
        return URL(string: "\(baseUrl)/token")!
    }
    
    // Get the client id string
    public func getClientId() -> String {
        return clientId
    }
    
    // Get the logout URL string
    public func getLogoutUrl(idToken: String, redirectUri: String) -> String {
        return String(format: LOGOUT_URL_TEMPLATE, baseUrl, TOKEN_HINT_FRAGMENT, idToken, REDIRECT_FRAGMENT, redirectUri)
    }
    
    // Get the URL string of the Keycloak service
    public func getHostUrl() -> String {
        return serverUrl
    }
    
    // Get the realm name of the Keycloak service
    public func getRealmName() -> String {
        return realmId
    }
    
    // Get the URL where JWKs can be retrieved
    public func getJwksUrl() -> String {
        return "\(baseUrl)/certs"
    }
    
    // Get the JWK Issuer
    public func getIssuer() -> String {
        return String(format: "%@/realms/%@", getHostUrl(), getRealmName())
    }
}
