//
//  AuthenticationConfig.swift
//  AGSAuth

import Foundation

/**
 Configurations for the authentication service
*/
struct AuthenticationConfig {
    let redirectURL: URL
    let minTimeBetweenJwksRequests: Int
    
    /**
     Initialises the authentication configuration
     
     - parameters:
        - redirectURL: the redirect URL for the developers app
        - minTimeBetweenJwksRequests: The minimum time, in minutes, between Json web key set requests. Default value is 1400 (1 day)
     */
    init(redirectURL: String, minTimeBetweenJwksRequests: Int = 24*60) {
        self.redirectURL = URL(string: redirectURL)!
        self.minTimeBetweenJwksRequests = minTimeBetweenJwksRequests
    }
}
