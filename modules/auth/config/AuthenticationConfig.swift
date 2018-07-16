//
//  AuthenticationConfig.swift
//  AGSAuth

import Foundation

/** Configurations for the authentication service */
public struct AuthenticationConfig {
    /** redirect url used during the authentication process */
    public let redirectURL: URL
    /** the minimum time between making JWKS requests */
    public let minTimeBetweenJwksRequests: UInt
    /** Flag used to perform login in external browser instead of webview */
    public let useExternalUserAgent: Bool

    /**
     Initialises the authentication configuration

     - parameters:
        - redirectURL: the redirect URL for the developers app
        - minTimeBetweenJwksRequests: The minimum time, in minutes, between Json web key set requests. Default value is 1400 (1 day)
     */
    public init(redirectURL: String, useExternalUserAgent: Bool = false, minTimeBetweenJwksRequests: UInt = 24 * 60) {
        self.redirectURL = URL(string: redirectURL)!
        self.minTimeBetweenJwksRequests = minTimeBetweenJwksRequests
        self.useExternalUserAgent = useExternalUserAgent
    }
}
