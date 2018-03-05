//
//  CredentialsManager.swift
//  AGSAuth

import Foundation
import AppAuth
import Security
import SwiftKeychainWrapper

public protocol CredentialManagerProtocol {
    func load() -> OIDCCredentials?
    func save(credentials: OIDCCredentials)
    func clear()
}

/** Persist/load the OIDCCredentials */
public class CredentialsManager : CredentialManagerProtocol {
    let AUTH_STATE_KEY = "authState"
    var authState: OIDAuthState?
    
    public init() {}

    /// Get the stored credentials.
    ///
    /// - Returns: The stored credentials.
    public func load() -> OIDCCredentials? {
        guard let state = KeychainWrapper.standard.object(forKey: AUTH_STATE_KEY) else {
            return nil
        }
        return OIDCCredentials(state: state as! OIDAuthState)
    }
    
    /// Overwrite the currently stored credentials.
    ///
    /// - Parameter credentials: The credentials to store.
    public func save(credentials: OIDCCredentials) {
        KeychainWrapper.standard.set(credentials.authState, forKey: AUTH_STATE_KEY)
    }
    
    /// Remove the currently stored credentials.
    public func clear() {
        KeychainWrapper.standard.removeObject(forKey: AUTH_STATE_KEY)
    }
}
