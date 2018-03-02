//
//  AuthConfig.swift
//  AGSAuth

import AGSCore
import Foundation

/** All the configurations related to Keycloak */
class KeycloakConfig {
    private let sdkId = "keycloak"

    public var rawConfig: MobileService?

    init(_ configService: ServiceConfig) {
        if let serviceConfig = configService[sdkId] {
            rawConfig = serviceConfig
        } else {
            AgsCore.logger.error("""
                Mobile configuration is missing auth service.
                Auth will not be enabled
                Please review sdk configuration file.
            """)
        }
    }

    func getLogoutUrl(idToken _: String) -> String {
        // TODO: implement this
        return ""
    }
}
