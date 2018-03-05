//
//  AuthenticationConfig.swift
//  AGSAuth

import Foundation

/** Configurations for the authentication service */
struct AuthenticationConfig {
    let redirectURL: URL
    let minTimeBetweenJwksRequests: Int
    
    init(redirectURL: String, minTimeBetweenJwksRequests: Int = 24*60) {
        self.redirectURL = URL(string: redirectURL)!
        self.minTimeBetweenJwksRequests = minTimeBetweenJwksRequests
    }
    
    public func getRedirectURL() -> URL {
        return redirectURL
    }
    
    public func getMinTimeBetweenJwksRequests() -> Int {
        return minTimeBetweenJwksRequests
    }
}
