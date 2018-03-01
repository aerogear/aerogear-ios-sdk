//
//  OIDCAuthenticatorTest.swift
//  AeroGearSdkExampleTests
//

import XCTest
@testable import AGSCore
@testable import AGSAuth


class OIDCAuthenticatorTest: XCTestCase {
    
    class MockCredentialManager: CredentialManagerProtocol {
        var loadCalled = false
        var saveCalled = false
        var clearCalled = false
        
        func load() -> OIDCCredentials? {
            loadCalled = true
            return nil
        }
        
        func save(credentials: OIDCCredentials) {
            saveCalled = true
        }
        
        func clear() {
            clearCalled = true
        }
    }
    
    var http = MockHttpRequest()
    var keycloakConfig : KeycloakConfig?
    var authConfig: AuthenticationConfig?
    var oidcAuthenticatorToTest: OIDCAuthenticator?
    var credentialManager: MockCredentialManager?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let serviceConfig = ServiceConfig()
        keycloakConfig = KeycloakConfig(serviceConfig)
        authConfig = AuthenticationConfig(redirectURL: URL(string: "com.aerogear.mobile.test://calback")!)
        credentialManager = MockCredentialManager()
        oidcAuthenticatorToTest = OIDCAuthenticator(http: http, keycloakConfig: keycloakConfig!, authConfig: authConfig!, credentialManager: credentialManager!)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLogoutSuccess() {
        let testUser = User(userName: "test", email: "test@example.com", accessToken: "testAccessToken", identityToken: "testIdentityToken", roles: [])
        http.dataForGet = "success"
        var onCompletedCalled = false
        oidcAuthenticatorToTest?.logout(currentUser: testUser, onCompleted: { (error) in
            XCTAssertNil(error)
            XCTAssertTrue(self.credentialManager!.clearCalled)
            onCompletedCalled = true
        })
        XCTAssertTrue(onCompletedCalled)
    }
    
    func testLogoutError() {
        let testUser = User(userName: "test", email: "test@example.com", accessToken: "testAccessToken", identityToken: "testIdentityToken", roles: [])
        http.errorForGet = MockHttpErrors.NetworkError
        var onCompletedCalled = false
        oidcAuthenticatorToTest?.logout(currentUser: testUser, onCompleted: { (error) in
            XCTAssertNotNil(error)
            XCTAssertFalse(self.credentialManager!.clearCalled)
            onCompletedCalled = true
        })
        XCTAssertTrue(onCompletedCalled)
    }

    
}
