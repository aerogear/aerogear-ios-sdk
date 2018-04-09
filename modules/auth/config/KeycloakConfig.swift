//
//  AuthConfig.swift
//  AGSAuth
import AGSCore
import Foundation

/** All the configurations related to Keycloak */
class KeycloakConfig {
    private let serverUrlName = "auth-server-url"
    private let realmIdName = "realm"
    private let clientIdName = "resource"

    private let tokenHintFragment = "id_token_hint"
    private let redirectFragment = "redirect_uri"

    private let baseUrlTemplate = "%@/realms/%@/protocol/openid-connect"
    private let logoutUrlTemplate = "%@/logout?%@=%@"

    private let authConfig: AuthenticationConfig

    private var serverUrl: String = ""
    private var realmId: String = ""
    private var clientId: String = ""
    private var baseUrl: String = ""
    private var logoutUrl: String = ""

    /** the mobile service configuration */
    public var rawConfig: MobileService?

    /**
     Initialises the keycloak configuration

     Tries to get the keycloak service configuration from the mobile services
     configuration. If the keycloak service configuration is nil, an error is logged. Else,
     `rawConfig` variable is set to the keycloak service configuration.

     - parameters:
        - mobileService: mobile services configuration
        - authConfig: configuration for the authentication service
     */
    init(_ mobileService: MobileService, _ authConfig: AuthenticationConfig) {
        self.authConfig = authConfig
        rawConfig = mobileService
        guard let config = mobileService.config else {
            AgsCore.logger.error("Missing keycloak configuration")
            return
        }

        if let url = config[serverUrlName] {
            serverUrl = url.getString() ?? ""
        }

        if let realm = config[realmIdName] {
            realmId = realm.getString() ?? ""
        }

        if let clientIdValue = config[clientIdName] {
            clientId = clientIdValue.getString() ?? ""
        }
        baseUrl = String(format: baseUrlTemplate, serverUrl, realmId)
    }

    /** The URL for the Keycloak authentication endpoint. */
    var authenticationEndpoint: URL {
        return URL(string: "\(baseUrl)/auth")!
    }

    /** The URL for the token exchange endpoint */
    var tokenEndpoint: URL {
        return URL(string: "\(baseUrl)/token")!
    }

    /** The client id string */
    var clientID: String {
        return clientId
    }

    /**
     Constructs the logout URL.

     - parameters:
        - idToken: the identity token
     - returns: logout URL
     */
    func buildLogoutURL(idToken: String) -> String {
        return String(format: logoutUrlTemplate, baseUrl, tokenHintFragment, idToken)
    }

    /** The URL string of the Keycloak service */
    var hostUrl: String {
        return serverUrl
    }

    /** The realm name of the Keycloak service */
    var realmName: String {
        return realmId
    }

    /** The URL where JWKs can be retrieved */
    var jwksUrl: String {
        return "\(baseUrl)/certs"
    }

    /** The JWK Issuer */
    var issuer: String {
        return String(format: "%@/realms/%@", hostUrl, realmName)
    }
}
