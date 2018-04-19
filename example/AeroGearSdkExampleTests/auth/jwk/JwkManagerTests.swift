//
//  JwkManagerTests.swift
//  AeroGearSdkExampleTests
//

@testable import AGSAuth
import SwiftKeychainWrapper
import XCTest

class JwkManagerTests: XCTestCase {
    var http = MockHttpRequest()
    var keycloakConfig: KeycloakConfig?
    var authConfig: AuthenticationConfig?
    var jwksManagerToTest: JwksManager?

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let serviceConfig = getMockKeycloakConfig()
        authConfig = AuthenticationConfig(redirectURL: "com.aerogear.mobile.test://calback")
        keycloakConfig = KeycloakConfig(serviceConfig, authConfig!)
        jwksManagerToTest = JwksManager(http, authConfig!)

        // create JWKS
        let jwks = try? JSONSerialization.data(withJSONObject: getMockJwks(), options: [])
        let jwksString = String(data: jwks!, encoding: .utf8)

        // persist JWKS & date
        KeychainWrapper.standard.set(jwksString!, forKey: "myproject_jwks_content")
        KeychainWrapper.standard.set(Date().timeIntervalSince1970, forKey: "myproject_requested_date")
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        KeychainWrapper.standard.removeObject(forKey: "myproject_jwks_content")
        KeychainWrapper.standard.removeObject(forKey: "myproject_requested_date")
    }

    func testLoadExistingJwks() {
        let jwksResult = jwksManagerToTest?.load(keycloakConfig!)
        XCTAssertEqual(jwksResult!.keys[0].kid, "adSoyXNAgQxV43eqHSiRZf6hN9ytvBNQyb2fFSdCTVM")
    }

    func testFetchJwksIfNeededForceFetch() {
        let needsFetch = jwksManagerToTest?.fetchJwksIfNeeded(keycloakConfig!, true)
        XCTAssertTrue(needsFetch!)
    }

    func testFetchJwksIfNeededShouldRequest() {
        let day: TimeInterval = 60.0 * 60.0 * 24
        let yesterday = Date().addingTimeInterval(-day).timeIntervalSince1970
        KeychainWrapper.standard.set(yesterday, forKey: "myproject_requested_date")

        let needsFetch = jwksManagerToTest?.fetchJwksIfNeeded(keycloakConfig!, false)
        XCTAssertTrue(needsFetch!)
    }

    func testFetchJwksWithCallback() {
        http.dataForGet = getMockJwks()
        var onCompletedCalled = false
        jwksManagerToTest?.fetchJwks(keycloakConfig!, onCompleted: { response, error in
            XCTAssertNil(error)
            let jwksKey: [String: String] = response!["keys"] as! [String: String]
            XCTAssertEqual(jwksKey["kid"], "adSoyXNAgQxV43eqHSiRZf6hN9ytvBNQyb2fFSdCTVM")
            onCompletedCalled = true
        })
        XCTAssertTrue(onCompletedCalled)
    }

    func testFetchJwksWithoutCallback() {
        jwksManagerToTest?.fetchJwks(keycloakConfig!)
        let persistedContent = KeychainWrapper.standard.string(forKey: "myproject_jwks_content")
        let jwksData = persistedContent?.data(using: .utf8)
        let jwks = try? JSONSerialization.jsonObject(with: jwksData!, options: .mutableLeaves) as! [String: Any]
        let jwksKeys = jwks!["keys"] as! [String: String]
        XCTAssertEqual(jwksKeys["kid"], "adSoyXNAgQxV43eqHSiRZf6hN9ytvBNQyb2fFSdCTVM")
    }
}
