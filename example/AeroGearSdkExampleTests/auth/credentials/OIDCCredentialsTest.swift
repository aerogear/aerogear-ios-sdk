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
    static let paramAccessTokenVal = "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJhZFNveVhOQWdReFY0M2VxSFNpUlpmNmhOOXl0dkJOUXliMmZGU2RDVFZNIn0.eyJqdGkiOiJlMzkzOGU2Zi0zOGQzLTQ2MmYtYTg1OS04YjNiODA0N2NlNzkiLCJleHAiOjE5NDg2MzI2NDgsIm5iZiI6MCwiaWF0IjoxNTE2NjMyNjQ4LCJpc3MiOiJodHRwczovL2tleWNsb2FrLnNlY3VyaXR5LmZlZWRoZW5yeS5vcmcvYXV0aC9yZWFsbXMvc2VjdXJlLWFwcCIsImF1ZCI6ImNsaWVudC1hcHAiLCJzdWIiOiJiMTYxN2UzOC0zODczLTRhNDctOGE2Yy01YjgyMmFkYTI3NWUiLCJ0eXAiOiJCZWFyZXIiLCJhenAiOiJjbGllbnQtYXBwIiwiYXV0aF90aW1lIjoxNTE2NjMyNjQ3LCJzZXNzaW9uX3N0YXRlIjoiYzI1NWYwYWMtODA5MS00YzkyLThmM2EtNDhmZmI4ODFhNzBiIiwiYWNyIjoiMSIsImFsbG93ZWQtb3JpZ2lucyI6WyIqIl0sInJlYWxtX2FjY2VzcyI6eyJyb2xlcyI6WyJtb2JpbGUtdXNlciJdfSwicmVzb3VyY2VfYWNjZXNzIjp7ImNsaWVudC1hcHAiOnsicm9sZXMiOlsiaW9zLWFjY2VzcyJdfSwiYWNjb3VudCI6eyJyb2xlcyI6WyJtYW5hZ2UtYWNjb3VudCIsIm1hbmFnZS1hY2NvdW50LWxpbmtzIiwidmlldy1wcm9maWxlIl19fSwibmFtZSI6IlVzZXIgMSIsInByZWZlcnJlZF91c2VybmFtZSI6InVzZXIxIiwiZ2l2ZW5fbmFtZSI6IlVzZXIiLCJmYW1pbHlfbmFtZSI6IjEiLCJlbWFpbCI6InVzZXIxQGZlZWRoZW5yeS5vcmcifQ.RvsLrOrLB3EFkZvYZM8-QXf6rRllCap-embNwa2V-NTMpcR7EKNMkKUQI9MbBlVSkTEBckZAK0DGSdo5CYuFoFH-xVWkzU0yQKBuFYAK1Etd50yQWwS1vHiThT95ZgeGGCB3ptafY5UCoqyg41kKqO5rb8iGyZ3ACp2xoEOE5S1rPAPszcQrbKBryOOk7H6MDZgqhZxxGUJkDVAT2v3jAd1aJ4K17qH6raabtDrAy_541vn6c0LS1ay0ooW4IVFzjFSH1-jMJvCYM6oku7brPonl2qHO8jMLrrhxylw2VXIAlregih6aNJ5c87729UtEJNTEFyqGI6GCunt2DQt7cw"
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
