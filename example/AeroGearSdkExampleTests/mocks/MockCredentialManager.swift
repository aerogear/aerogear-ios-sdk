//
//  MockCredentialManager.swift
//  AeroGearSdkExampleTests
//
//  Created by Massimiliano Ziccardi on 12/03/2018.
//  Copyright © 2018 AeroGear. All rights reserved.
//

@testable import AGSAuth
import Foundation
import AppAuth

class MockCredentialManager: CredentialManagerProtocol {
    var loadCalled = false
    var saveCalled = false
    var clearCalled = false
    
    func load() -> OIDCCredentials? {
        loadCalled = true
        return nil
    }
    
    func save(credentials _: OIDCCredentials) {
        saveCalled = true
    }
    
    func clear() {
        clearCalled = true
    }
}
