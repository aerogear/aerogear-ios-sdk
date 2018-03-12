//
//  OIDCAuthenticatorTest.swift
//  AeroGearSdkExampleTests
//

@testable import AGSAuth
@testable import AGSCore
import XCTest
import AppAuth

class OIDCAuthenticatorTest: XCTestCase {
    
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
    
    class MockOIDAuthorizationFlowSession : NSObject, OIDAuthorizationFlowSession {
        func cancel() {
        }
        func resumeAuthorizationFlow(with URL: URL) -> Bool {
            return false
        }
        func failAuthorizationFlowWithError(_ error: Error) {
        }
    }
    
    class MockUIViewController : UIViewController {
    }
    
    var http = MockHttpRequest()
    var keycloakConfig: KeycloakConfig?
    var authConfig: AuthenticationConfig?
    var oidcAuthenticatorToTest: OIDCAuthenticator?
    var credentialManager: MockCredentialManager?

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let serviceConfig = getMockKeycloakConfig()
        authConfig = AuthenticationConfig(redirectURL: "com.aerogear.mobile.test://calback")
        keycloakConfig = KeycloakConfig(serviceConfig, authConfig!)
        credentialManager = MockCredentialManager()
        oidcAuthenticatorToTest = OIDCAuthenticator(http: http, keycloakConfig: keycloakConfig!, authConfig: authConfig!, credentialManager: credentialManager!)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testLogoutSuccess() {
        let testUser = User(userName: "test", email: "test@example.com", firstName: nil, lastName: nil, accessToken: "testAccessToken", identityToken: "testIdentityToken", roles: [])
        http.dataForGet = "success"
        var onCompletedCalled = false
        oidcAuthenticatorToTest?.logout(currentUser: testUser, onCompleted: { error in
            XCTAssertNil(error)
            XCTAssertTrue(self.credentialManager!.clearCalled)
            onCompletedCalled = true
        })
        XCTAssertTrue(onCompletedCalled)
    }

    func testLogoutError() {
        let testUser = User(userName: "test", email: "test@example.com", firstName: nil, lastName: nil, accessToken: "testAccessToken", identityToken: "testIdentityToken", roles: [])
        http.errorForGet = MockHttpErrors.NetworkError
        var onCompletedCalled = false
        oidcAuthenticatorToTest?.logout(currentUser: testUser, onCompleted: { error in
            XCTAssertNotNil(error)
            XCTAssertFalse(self.credentialManager!.clearCalled)
            onCompletedCalled = true
        })
        XCTAssertTrue(onCompletedCalled)
    }
    
    func testLoginFail() {
        var onCompletedCalled = false
        let authenticator = MockOIDCAuthenticator(http: http, keycloakConfig: keycloakConfig!, authConfig: authConfig!, credentialManager: credentialManager!, fail: true)
        
        authenticator.authenticate(presentingViewController: MockUIViewController()) {
            user, error in
            
            XCTAssertNil(user)
            XCTAssertNotNil(error)
            onCompletedCalled = true
        }
        XCTAssertTrue(onCompletedCalled)
    }
    
    func testLoginSuccess() {
        var onCompletedCalled = false
        let authenticator = MockOIDCAuthenticator(http: http, keycloakConfig: keycloakConfig!, authConfig: authConfig!, credentialManager: credentialManager!)

        authenticator.authenticate(presentingViewController: MockUIViewController()) {
            user, error in

            XCTAssertNil(error)
            XCTAssertNotNil(user)
            onCompletedCalled = true
        }
        XCTAssertTrue(onCompletedCalled)
    }
}
