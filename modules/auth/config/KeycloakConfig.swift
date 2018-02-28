//
//  AuthConfig.swift
//  AGSAuth

import Foundation
import AGSCore

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
}
