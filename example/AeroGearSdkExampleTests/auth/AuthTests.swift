//
// Copyright (c) 2018 AeroGear. All rights reserved.
//

@testable import AGSCore
@testable import AGSAuth
import Foundation
import XCTest

class AuthTests: XCTestCase {
    
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
    """.data(using: .utf8)!
    
    var mobileServiceConfig: MobileService?
    var authService: AgsAuth?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mobileServiceConfig = try? JSONDecoder().decode(MobileService.self, from: mobileServiceData)
        authService = AgsAuth(mobileServiceConfig!)
        authService?.configure(authConfig: AuthenticationConfig(redirectURL: "com.aerogear.auth://callback"))
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testConfigureNotCalled() {
        let authServiceNotConfigured = AgsAuth(mobileServiceConfig!)
        func callback(user: User?, error: Error?) {
            
        }
        XCTAssertThrowsError(try authServiceNotConfigured.login(presentingViewController: UIViewController(), onCompleted: callback))
        XCTAssertThrowsError(try authServiceNotConfigured.logout(onCompleted: { _ in
            
        }))
        XCTAssertThrowsError(try authServiceNotConfigured.currentUser())
        let url = URL(string: "http://example.com")
        XCTAssertThrowsError(try authServiceNotConfigured.resumeAuth(url: url!))
    }
}
