//
//  CredentialsManager.swift
//  AGSAuth

import AppAuth
import Foundation
import Security
import SwiftKeychainWrapper

public protocol CredentialManagerProtocol {
    func load() -> OIDCCredentials?
    func save(credentials: OIDCCredentials)
    func clear()
}

/** Persist/load the OIDCCredentials */
public class CredentialsManager: CredentialManagerProtocol {
    let authStateKey = "authState"
    var authState: OIDAuthState?

    public init() {}
    /**
     Get the stored credentials.
 
     - Returns: The stored credentials.
    */
    public func load() -> OIDCCredentials? {
        if let state = KeychainWrapper.standard.object(forKey: authStateKey) {
            return OIDCCredentials(state: state as! OIDAuthState)
        }
        return nil
    }

    /**
     Overwrite the currently stored credentials.
 
     - Parameter credentials: The credentials to store.
    */
    public func save(credentials: OIDCCredentials) {
        KeychainWrapper.standard.set(credentials.authState, forKey: authStateKey)
    }

    /** Remove the currently stored credentials. */
    public func clear() {
        KeychainWrapper.standard.removeObject(forKey: authStateKey)
    }
}
