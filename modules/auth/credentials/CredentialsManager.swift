//
//  CredentialsManager.swift
//  AGSAuth

import AppAuth
import Foundation
import Security
import SwiftKeychainWrapper

/** Persist/load credentials */
public protocol CredentialManagerProtocol {
    /**
     Get the stored credentials.
     
     - Returns: The stored credentials.
     */
    func load() -> OIDCCredentials?
    
    /**
     Overwrite the currently stored credentials.
     
     - Parameter credentials: The credentials to store.
     */
    func save(credentials: OIDCCredentials)

    /** Remove the currently stored credentials. */
    func clear()
}

/** Persist/load the OIDCCredentials */
public class CredentialsManager: CredentialManagerProtocol {
    let authStateKey = "org.aerogear.AuthState"
    var authState: OIDAuthState?

    public init() {}
    
    public func load() -> OIDCCredentials? {
        if let state = KeychainWrapper.standard.object(forKey: authStateKey) {
            return OIDCCredentials(state: state as! OIDAuthState)
        }
        return nil
    }

    public func save(credentials: OIDCCredentials) {
        KeychainWrapper.standard.set(credentials.authState, forKey: authStateKey)
    }

    public func clear() {
        KeychainWrapper.standard.removeObject(forKey: authStateKey)
    }
}
