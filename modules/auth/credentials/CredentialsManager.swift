//
//  CredentialsManager.swift
//  AGSAuth

import Foundation

protocol CredentialManagerProtocol {
    func load() -> OIDCCredentials?
    func save(credentials: OIDCCredentials)
    func clear()
}

/** Persist/load the OIDCCredentials */
class CredentialsManager: CredentialManagerProtocol {
    func load() -> OIDCCredentials? {
        return nil
    }

    func save(credentials: OIDCCredentials) {

    }

    /** Remove local credentials*/
    func clear() {

    }
}
