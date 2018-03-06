//
//  KeycloakConfigTests.swift
//  AeroGearSdkExampleTests
//
//  Copyright © 2018 AeroGear. All rights reserved.
//

@testable import AGSAuth
@testable import AGSCore
import Foundation
import XCTest

class KeycloakConfigTests: XCTestCase {
    
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
        "ssl-required": "external",
        "url": "https://keycloak-myproject.192.168.64.74.nip.io/auth"
      }
    }
    """.data(using: .utf8)
    
    var configService: MobileService?
    var keycloakConfig: KeycloakConfig?
    var authConfig: AuthenticationConfig?
    
    override func setUp() {
        super.setUp()
        configService = try? JSONDecoder().decode(MobileService.self, from: mobileServiceData!)
        authConfig = AuthenticationConfig(redirectURL: "com.aerogear.mobile.test://calback")
        keycloakConfig = KeycloakConfig(configService!, authConfig!)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testKeycloakConfig() {
        XCTAssertNotNil(keycloakConfig?.rawConfig)
    }
    
    func testAuthenticationEndpoint() {
        let actual = keycloakConfig?.authenticationEndpoint
        let expected = URL(string: "https://keycloak-myproject.192.168.64.74.nip.io/auth/realms/myproject/protocol/openid-connect/auth")
        
        XCTAssertEqual(expected, actual)
    }
    
    func testTokenEndpoint() {
        let actual = keycloakConfig?.tokenEndpoint
        let expected = URL(string: "https://keycloak-myproject.192.168.64.74.nip.io/auth/realms/myproject/protocol/openid-connect/token")

        XCTAssertEqual(expected, actual)
    }
    
    func testClientID() {
        let actual = keycloakConfig?.clientID
        let expected = "juYAlRlhTyYYmOyszFa"

        XCTAssertEqual(expected, actual)
    }
    
    func testLogoutURL() {
        let actual = keycloakConfig?.buildLogoutURL(idToken: "testToken")
        let expected = "https://keycloak-myproject.192.168.64.74.nip.io/auth/realms/myproject/protocol/openid-connect/logout?id_token_hint=testToken&redirect_uri=com.aerogear.mobile.test://calback"
        
        XCTAssertEqual(expected, actual)
    }
    
    func testHostURL() {
        let actual = keycloakConfig?.hostUrl
        let expected = "https://keycloak-myproject.192.168.64.74.nip.io/auth"
        
        XCTAssertEqual(expected, actual)
    }
    
    func testRealmName() {
        let actual = keycloakConfig?.realmName
        let expected = "myproject"
        
        XCTAssertEqual(expected, actual)
    }
    
    func testJwksURL() {
        let actual = keycloakConfig?.jwksUrl
        let expected = "https://keycloak-myproject.192.168.64.74.nip.io/auth/realms/myproject/protocol/openid-connect/certs"
        
        XCTAssertEqual(expected, actual)
    }
    
    func testIssuer() {
        let actual = keycloakConfig?.issuer
        let expected = "https://keycloak-myproject.192.168.64.74.nip.io/auth/realms/myproject"
        
        XCTAssertEqual(expected, actual)
    }
}
