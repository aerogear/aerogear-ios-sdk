//
//  MockOIDCAuthenticator.swift
//  AeroGearSdkExampleTests
//
//  Created by Massimiliano Ziccardi on 12/03/2018.
//  Copyright © 2018 AeroGear. All rights reserved.
//

@testable import AGSCore
@testable import AGSAuth
import Foundation
import AppAuth

class MockOIDCAuthenticator : OIDCAuthenticator {
    
    let fail: Bool
    
    init(http: AgsHttpRequestProtocol, keycloakConfig: KeycloakConfig, authConfig: AuthenticationConfig, credentialManager: CredentialManagerProtocol, fail: Bool = false) {
        self.fail = fail
        super.init(http: http, keycloakConfig: keycloakConfig, authConfig: authConfig, credentialManager: credentialManager)
    }
    
    override func startAuthorizationFlow(byPresenting: OIDAuthorizationRequest, presenting: UIViewController, callback: @escaping (OIDCCredentials?, Error?) -> Void) -> OIDAuthorizationFlowSession {
        var testCredential: OIDCCredentials?
        var err: NSError?
        
        if (fail) {
            testCredential = nil
            err = NSError(domain: "errordomain", code: 123, userInfo: nil)
        } else {
            testCredential = OIDCCredentialsTest.buildCredentialsWithParameters(parameters: OIDCCredentialsTest.defaultParameters)
            err = nil
        }
        
        callback(testCredential, err)
        
        return MockOIDAuthorizationFlowSession()
    }
}
