//
//  CredentialsManager.swift
//  AGSAuth

import Foundation
import Security
import SwiftKeychainWrapper

/** Persist/load/remove credentials */
public protocol CredentialManagerProtocol {
    /**
     Get the stored credentials.

     - returns: The stored credentials.
     */
    func load() -> OIDCCredentials?

    /**
     Overwrite the currently stored credentials.

     - parameter
        - credentials: The credentials to store.
     */
    func save(credentials: OIDCCredentials)

    /** Remove the currently stored credentials. */
    func clear()
}

/** Persist/load/remove the OIDCCredentials */
public class CredentialsManager: CredentialManagerProtocol {
    /** The key used for storing and loading `openid` credentials */
    let authStateKey = "org.aerogear.AuthState"

    /** Initialises the credentials manager */
    public init() {}

    /**
     Fetches the `openid` credentials from local storage.

     - returns: `openid` credentials
     */
    public func load() -> OIDCCredentials? {
        if let state = KeychainWrapper.standard.object(forKey: authStateKey) {
            return state as? OIDCCredentials
        }
        return nil
    }

    /**
     Persists and overwrites the current `openid` credentials.

     - parameters:
        - credentials: `openid` credentials to save
     */
    public func save(credentials: OIDCCredentials) {
        KeychainWrapper.standard.set(credentials, forKey: authStateKey)
    }

    /** Deletes the currently stored `openid` credentials. */
    public func clear() {
        KeychainWrapper.standard.removeObject(forKey: authStateKey)
    }
}
