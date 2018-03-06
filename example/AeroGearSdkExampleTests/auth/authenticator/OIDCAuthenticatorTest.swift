//
//  OIDCAuthenticatorTest.swift
//  AeroGearSdkExampleTests
//

@testable import AGSAuth
@testable import AGSCore
import XCTest

class OIDCAuthenticatorTest: XCTestCase {

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
    
    let mobileServiceData =
        """
    {
      "id": "keycloak",
      "name": "keycloak",
      "type": "keycloak",
      "url": "https://www.mocky.io/v2/5a6b59fb31000088191b8ac6",
      "config": {
        "auth-server-url": "https://keycloak-myproject.192.168.64.74.nip.io/auth",
        "clientId": "juYAlRlhTyYYmOyszFa",
        "realm": "myproject",
        "resource": "juYAlRlhTyYYmOyszFa",
        "url": "https://keycloak-myproject.192.168.64.74.nip.io/auth"
      }
    }
    """.data(using: .utf8)

    var http = MockHttpRequest()
    var keycloakConfig: KeycloakConfig?
    var authConfig: AuthenticationConfig?
    var oidcAuthenticatorToTest: OIDCAuthenticator?
    var credentialManager: MockCredentialManager?

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let serviceConfig = try? JSONDecoder().decode(MobileService.self, from: mobileServiceData!)
        authConfig = AuthenticationConfig(redirectURL: "com.aerogear.mobile.test://calback")
        keycloakConfig = KeycloakConfig(serviceConfig!, authConfig!)
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
}

