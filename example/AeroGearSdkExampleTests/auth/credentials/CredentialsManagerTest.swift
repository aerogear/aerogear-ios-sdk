//
//  CredentialsManagerTest.swift
//  AeroGearSdkExampleTests

@testable import AGSAuth
import XCTest

class CredentialsManagerTest: XCTestCase {
    let testCredentialManager = CredentialsManager()

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testSaveLoadNotNil() {
        let testCredential = OIDCCredentialsTest.buildCredentialsWithParameters(parameters: OIDCCredentialsTest.defaultParameters)
        testCredentialManager.save(credentials: testCredential)
        let loadedCredentials = testCredentialManager.load()
        XCTAssertTrue(loadedCredentials?.getAccessToken() == OIDCCredentialsTest.paramAccessTokenVal)
        XCTAssertTrue(loadedCredentials?.getRefreshToken() == OIDCCredentialsTest.paramRefreshTokenVal)
        XCTAssertTrue(loadedCredentials?.getIdentitityToken() == OIDCCredentialsTest.paramIdTokenVal)
    }

    func testLoadNil() {
        XCTAssertTrue(testCredentialManager.load() == nil)
    }

    func testClear() {
        let testCredential = OIDCCredentialsTest.buildCredentialsWithParameters(parameters: OIDCCredentialsTest.defaultParameters)
        testCredentialManager.save(credentials: testCredential)
        testCredentialManager.clear()
        XCTAssertNil(testCredentialManager.load())
    }
}
