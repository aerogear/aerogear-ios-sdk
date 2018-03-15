//
// Copyright (c) 2018 AeroGear. All rights reserved.
//

@testable import AGSAuth
@testable import AGSCore
import Foundation
import XCTest

class AuthTests: XCTestCase {

    var mobileServiceConfig: MobileService?
    var authService: AgsAuth?

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mobileServiceConfig = getMockKeycloakConfig()
        authService = AgsAuth(mobileServiceConfig!)
        try! authService?.configure(authConfig: AuthenticationConfig(redirectURL: "com.aerogear.auth://callback"))
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
