//
//  UsersTests.swift
//  AeroGearSdkExampleTests
//

@testable import AGSAuth
import XCTest

class KeycloakUserProfileTests: XCTestCase {
    let userProfileJson = """
    {
        "name": "Username",
        "preferred_username": "Preferred Username",
        "given_name": "First",
        "family_name": "Last",
        "email": "username@example.com",
        "realm_access": {
            "roles": ["realmRole"],
            "verify_caller": false
        },
        "resource_access": {
            "exampleClient": {
                "roles": ["clientRole"],
                "verify_caller": false
            }
        }
    }
    """.data(using: .utf8)

    var userProfileToTest: KeycloakUserProfile?

    override func setUp() {
        super.setUp()
        userProfileToTest = try! JSONDecoder().decode(KeycloakUserProfile.self, from: userProfileJson!)
    }

    override func tearDown() {
        super.tearDown()
    }

    func testParsedUserProfile() {
        XCTAssertNotNil(userProfileToTest)
        XCTAssertEqual(userProfileToTest?.email, "username@example.com")
        XCTAssertEqual(userProfileToTest?.username, "Preferred Username")
        XCTAssertEqual(userProfileToTest?.firstName, "First")
        XCTAssertEqual(userProfileToTest?.lastName, "Last")
        XCTAssertEqual(userProfileToTest?.realmRoles.count, 1)
        XCTAssertEqual(userProfileToTest?.realmRoles.first, "realmRole")
        XCTAssertEqual(userProfileToTest?.getClientRoles("exampleClient").count, 1)
        XCTAssertEqual(userProfileToTest?.getClientRoles("exampleClient").first, "clientRole")
        XCTAssertEqual(userProfileToTest?.getUserRoles(forClient: "exampleClient").count, 2)
        XCTAssertTrue(userProfileToTest!.getUserRoles(forClient: "exampleClient").contains(UserRole(nameSpace: nil, roleName: "realmRole")))
        XCTAssertTrue(userProfileToTest!.getUserRoles(forClient: "exampleClient").contains(UserRole(nameSpace: "exampleClient", roleName: "clientRole")))
    }
}

class UsersTests: XCTestCase {
    let identityToken = "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJhZFNveVhOQW"
        + "dReFY0M2VxSFNpUlpmNmhOOXl0dkJOUXliMmZGU2RDVFZNIn0.eyJqdGkiOiI4OGQ2MDY0Ni00YzA4LTQwYmMtYTh"
        + "jMy00MzA3MmI4N2ZmMGQiLCJleHAiOjE1MjA5NjA5OTAsIm5iZiI6MCwiaWF0IjoxNTIwOTU5MTkwLCJpc3MiOiJo"
        + "dHRwczovL2tleWNsb2FrLnNlY3VyaXR5LmZlZWRoZW5yeS5vcmcvYXV0aC9yZWFsbXMvc2VjdXJlLWFwcCIsImF1Z"
        + "CI6ImNsaWVudC1hcHAiLCJzdWIiOiJiMTYxN2UzOC0zODczLTRhNDctOGE2Yy01YjgyMmFkYTI3NWUiLCJ0eXAiOi"
        + "JJRCIsImF6cCI6ImNsaWVudC1hcHAiLCJhdXRoX3RpbWUiOjE1MjA5NTkxODksInNlc3Npb25fc3RhdGUiOiJmZTR"
        + "mN2YxZi0wMzJiLTRlMjEtOTZlMS0zMGFkMjA2NzJlNTEiLCJhY3IiOiIxIiwiYm9vbGVhbiI6dHJ1ZSwic3RyaW5n"
        + "Ijoic3RyaW5nIiwibmFtZSI6IlVzZXIgMSIsInByZWZlcnJlZF91c2VybmFtZSI6InVzZXIxIiwiZ2l2ZW5fbmFtZ"
        + "SI6IlVzZXIiLCJmYW1pbHlfbmFtZSI6IjEiLCJlbWFpbCI6InVzZXIxQGZlZWRoZW5yeS5vcmciLCJpbnQiOjEsIm"
        + "xvbmciOjF9.OJ1K3h9kOccsLmAxNo_FOoy2L5BWTl2u9K3Y6HhteGKL8rd293sM856-Da8ZiuScSd6wGzk2lQjpCG"
        + "Cv_YUaduRGtN7RMtI61P4zYeYZj4z08A65ZhgXUDqIMkCvqgcSFkBdJvKeZBGeogWttqu6k_0oMHIywgWrxFm9uNw"
        + "66F8-3jwbOP-hdZDGFeCf9EhOcT9EzZ56nGRfWZI_FPjo0VRmRyixmLF3ulIZ_yrlcRAUNdW3g-GVTsUgO2DIXW45"
        + "xt-_Kz1AQRhMRW50775_TZOlWt__wRrt9-Y4Qn_KHfiPaCqDAbzAdNpJJLo0S_yemEqV9pEWEQE4ZoVA9hwypQ"
    let realmRole: UserRole = UserRole(nameSpace: nil, roleName: "realmRole")
    let clientRole: UserRole = UserRole(nameSpace: "client", roleName: "clientRole")
    var userToTest: User?

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let roles: Set<UserRole> = [realmRole, clientRole]
        userToTest = User(userName: "test", email: "test@example.com", firstName: "First", lastName: "Last", accessToken: "", identityToken: identityToken, roles: roles)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testProperties() {
        XCTAssertEqual(userToTest?.fullName, "First Last")
    }

    func testHasRoles() {
        XCTAssertTrue(userToTest!.hasRealmRole("realmRole"))
        XCTAssertTrue(userToTest!.hasClientRole(client: "client", role: "clientRole"))
        XCTAssertFalse(userToTest!.hasRealmRole("wrongRealmRole"))
        XCTAssertFalse(userToTest!.hasClientRole(client: "clientNotExist", role: "clientRole"))
    }

    func testCustomBooleanAttribute() {
        let booleanAttribute: Bool? = (userToTest?.customAttribute("boolean"))
        let nonExistentCustomAttribute: Bool? = (userToTest?.customAttribute("nonExistentCustomAttribute"))
        XCTAssertEqual(booleanAttribute, true)
        XCTAssertEqual(nonExistentCustomAttribute, nil)
    }

    func testCustomStringAttribute() {
        let stringAttribute: String? = (userToTest?.customAttribute("string"))
        let nonExistentCustomAttribute: String? = (userToTest?.customAttribute("nonExistentCustomAttribute"))
        XCTAssertEqual(stringAttribute, "string")
        XCTAssertEqual(nonExistentCustomAttribute, nil)
    }

    func testCustomLongAttribute() {
        let longAttribute: Int64? = (userToTest?.customAttribute("long"))
        let nonExistentCustomAttribute: Int64? = (userToTest?.customAttribute("nonExistentCustomAttribute"))
        XCTAssertEqual(longAttribute, 1)
        XCTAssertEqual(nonExistentCustomAttribute, nil)
    }

    func testCustomIntAttribute() {
        let intAttribute: Int? = (userToTest?.customAttribute("int"))
        let nonExistentCustomAttribute: Int? = (userToTest?.customAttribute("nonExistentCustomAttribute"))
        XCTAssertEqual(intAttribute, 1)
        XCTAssertEqual(nonExistentCustomAttribute, nil)
    }
}
