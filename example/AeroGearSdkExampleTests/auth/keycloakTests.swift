//
//  Copyright © 2018 AeroGear. All rights reserved.
//

@testable import AGSAuth
import AGSCore
import Foundation
import XCTest

class KeycloakConfigTests: XCTestCase {
    
    var configService: ServiceConfig?
    var keycloakConfig: KeycloakConfig?
    
    override func setUp() {
        super.setUp()
        configService = ServiceConfig.init();
        keycloakConfig = KeycloakConfig.init(configService!)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testKeycloakConfig() {
        XCTAssertNotNil(keycloakConfig?.rawConfig)
    }
    
    func testKeycloakConfigNull() {
        let nilConfigService = ServiceConfig.init("nonExistent")
        let nilKeycloakConfig = KeycloakConfig.init(nilConfigService)
        XCTAssertNil(nilKeycloakConfig.rawConfig)
    }
    
    func testGetters() {
        let authEndpointActual = keycloakConfig?.getAuthenticationEndpoint()
        let authEndpointExpected = URL(string: "https://keycloak-myproject.192.168.64.74.nip.io/auth/realms/myproject/protocol/openid-connect/auth")
        
        let tokenEndpointActual = keycloakConfig?.getTokenEndpoint()
        let tokenEndpointExpected = URL(string: "https://keycloak-myproject.192.168.64.74.nip.io/auth/realms/myproject/protocol/openid-connect/token")
        
        let clientIdActual = keycloakConfig?.getClientId()
        let clientIdExpected = "juYAlRlhTyYYmOyszFa"
        
        let logoutUrlActual = keycloakConfig?.getLogoutUrl(idToken: "dummyValue", redirectUri: "dummyValue")
        let logoutUrlExpected = "https://keycloak-myproject.192.168.64.74.nip.io/auth/realms/myproject/protocol/openid-connect/logout?id_token_hint=dummyValue&redirect_uri=dummyValue"
        
        XCTAssertEqual(authEndpointExpected, authEndpointActual)
        XCTAssertEqual(tokenEndpointExpected, tokenEndpointActual)
        XCTAssertEqual(clientIdExpected, clientIdActual)
        XCTAssertEqual(logoutUrlExpected, logoutUrlActual)
    }
}
