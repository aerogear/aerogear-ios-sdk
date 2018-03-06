//
//  AuthConfig.swift
//  AGSAuth
import AGSCore
import Foundation

/**
 All the configurations related to Keycloak
 */
class KeycloakConfig {
    private let sdkId = "keycloak"
    
    private let serverUrlName = "auth-server-url"
    private let realmIdName = "realm"
    private let clientIdName = "resource"
    
    private let tokenHintFragment = "id_token_hint"
    private let redirectFragment = "redirect_uri"
    
    private let baseUrlTemplate = "%@/realms/%@/protocol/openid-connect"
    private let logoutUrlTemplate = "%@/logout?%@=%@&%@=%@"
    
    private let authConfig: AuthenticationConfig
    
    private var serverUrl: String = ""
    private var realmId: String = ""
    private var clientId: String = ""
    private var baseUrl: String = ""
    private var logoutUrl: String = ""
    
    public var rawConfig: MobileService?
    
    /**
     Initialises the keycloak configuration
     
     Tries to get the keycloak service configuration from the mobile services
     configuration. If the keycloak service configuration is nil, an error is logged. Else,
     *rawConfig* variable is set to the keycloak service configuration.
     
     - parameters:
        - configService: mobile services configuration
        - authConfig: configuration for the authentication service
     */
    init(_ configService: ServiceConfig, _ authConfig: AuthenticationConfig) {
        self.authConfig = authConfig
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
    
    /**
     Get the URL for the Keycloak authentication endpoint
     */
    var authenticationEndpoint: URL {
        return URL(string: "\(baseUrl)/auth")!
    }
    
    /**
     Get the URL for the token exchange endpoint
     */
    var tokenEndpoint: URL {
        return URL(string: "\(baseUrl)/token")!
    }
    
    /**
     Get the client id string
     */
    var clientID: String {
        return clientId
    }
    
    /**
     Constructs the logout URL
     
     - parameters:
        - idToken: the identity token
     - returns: logout URL
     */
    func buildLogoutURL(idToken: String) -> String {
        return String(format: logoutUrlTemplate, baseUrl, tokenHintFragment, idToken, redirectFragment, authConfig.redirectURL.absoluteString)
    }
    
    /**
     Get the URL string of the Keycloak service
     */
    var hostUrl: String {
        return serverUrl
    }
    
    /**
     Get the realm name of the Keycloak service
     */
    var realmName: String {
        return realmId
    }
    
    /**
     Get the URL where JWKs can be retrieved
     */
    var jwksUrl: String {
        return "\(baseUrl)/certs"
    }
    
    /**
     Get the JWK Issuer
     */
    var issuer: String {
        return String(format: "%@/realms/%@", hostUrl, realmName)
    }
    
}
