//
//  OIDCCredentialsTest.swift
//  AeroGearSdkExampleTests
//

@testable import AGSAuth
import AppAuth
import XCTest

internal class OIDCCredentialsTest: XCTestCase {
    static let paramCodeKey = "code"
    static let paramCodeVerifierKey = "code_verifier"
    static let paramStateKey = "state"
    static let paramAccessTokenKey = "access_token"
    static let paramExpiresInKey = "expires_in"
    static let paramIdTokenKey = "id_token"
    static let paramTokenTypeKey = "token_type"
    static let paramScopeKey = "scope"
    static let paramRefreshTokenKey = "refresh_token"

    static let paramCodeVal = "testCode"
    static let paramCodeVerifierVal = "testVerifier"
    static let paramStateVal = "testState"
    static let paramAccessTokenVal = "testAccessToken"
    static let paramExpiresInVal = 60
    static let paramIdTokenVal = "testIdentityToken"
    static let paramTokenTypeVal = "testTokenType"
    static let paramScopeVal = "testScope"
    static let paramRefreshTokenVal = "testRefreshToken"

    static let defaultParameters = [
        paramCodeKey: paramCodeVal as NSString,
        paramCodeVerifierKey: paramCodeVerifierVal as NSString,
        paramStateKey: paramStateVal as NSString,
        paramAccessTokenKey: paramAccessTokenVal as NSString,
        paramExpiresInKey: paramExpiresInVal as NSNumber,
        paramIdTokenKey: paramIdTokenVal as NSString,
        paramTokenTypeKey: paramTokenTypeVal as NSString,
        paramScopeKey: paramScopeVal as NSString,
        paramRefreshTokenKey: paramRefreshTokenVal as NSString,
    ] as [String: NSObject & NSCopying]

    var testCredentials: OIDCCredentials?

    override func setUp() {
        super.setUp()
        testCredentials = OIDCCredentialsTest.buildCredentialsWithParameters(parameters: OIDCCredentialsTest.defaultParameters)
    }

    override func tearDown() {
        super.tearDown()
    }

    func testGetAccessToken() {
        XCTAssertEqual(testCredentials?.accessToken, OIDCCredentialsTest.paramAccessTokenVal)
    }

    func testGetIdentityToken() {
        XCTAssertEqual(testCredentials?.identityToken, OIDCCredentialsTest.paramIdTokenVal)
    }

    func testGetRefreshToken() {
        XCTAssertEqual(testCredentials?.refreshToken, OIDCCredentialsTest.paramRefreshTokenVal)
    }

    func testIsExpired() {
        XCTAssertFalse((testCredentials?.isExpired)!)
    }

    func testIsExpiredWithExpiredToken() {
        var expiredParameters = OIDCCredentialsTest.defaultParameters
        expiredParameters[OIDCCredentialsTest.paramExpiresInKey] = 0 as NSNumber

        let expiredCredentials = OIDCCredentialsTest.buildCredentialsWithParameters(parameters: expiredParameters)
        XCTAssertTrue(expiredCredentials.isExpired)
    }

    func testIsAuthorized() {
        XCTAssertTrue((testCredentials?.isAuthorized)!)
    }

    func testIsAuthorizedWithUnauthorizedState() {
        let unauthorizedCredentials = OIDCCredentialsTest.buildCredentialsWithParameters(parameters: [:])
        XCTAssertFalse(unauthorizedCredentials.isAuthorized)
    }

    /**
     Create an OIDCCredentials instance backed by an OIDAuthState with the provided parameters for a token response.
     This allows for mocking most of the important values that are used by OIDCCredentials.
 
     - Parameter parameters: The parameters to mock being provided by a token response e.g. access_token, expires_in.
     - Returns: An OIDCCredentials instance backed by a mocked AuthState using the parameters provided.
    */
    internal static func buildCredentialsWithParameters(parameters: [String: NSObject & NSCopying]) -> OIDCCredentials {
        let testUrl = URL(string: "https://example.example")!
        let testServiceConfig = OIDServiceConfiguration(authorizationEndpoint: testUrl, tokenEndpoint: testUrl)
        let testRequest = OIDAuthorizationRequest(configuration: testServiceConfig,
                                                  clientId: "exampleClientId",
                                                  clientSecret: "exampleClientSecret",
                                                  scope: "exampleClientScope",
                                                  redirectURL: testUrl,
                                                  responseType: "code",
                                                  state: "testState",
                                                  codeVerifier: "testVerifier",
                                                  codeChallenge: OIDAuthorizationRequest.codeChallengeS256(forVerifier: "testVerifier"),
                                                  codeChallengeMethod: OIDOAuthorizationRequestCodeChallengeMethodS256,
                                                  additionalParameters: [:])
        let testResponse = OIDAuthorizationResponse(request: testRequest, parameters: [:])

        let testTokenRequest = OIDTokenRequest(configuration: testServiceConfig,
                                               grantType: OIDGrantTypeAuthorizationCode,
                                               authorizationCode: "Code",
                                               redirectURL: testUrl,
                                               clientID: "testClientId",
                                               clientSecret: "testSecret",
                                               scope: "testScope",
                                               refreshToken: "testRefreshToken",
                                               codeVerifier: "testVerifier",
                                               additionalParameters: nil)
        let testTokenResponse = OIDTokenResponse(request: testTokenRequest, parameters: parameters)

        let authState = OIDAuthState(authorizationResponse: testResponse, tokenResponse: testTokenResponse)
        return OIDCCredentials(state: authState)
    }
}
