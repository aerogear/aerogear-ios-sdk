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
    let realmRole: UserRole = UserRole(nameSpace: nil, roleName: "realmRole")
    let clientRole: UserRole = UserRole(nameSpace: "client", roleName: "clientRole")
    var userToTest: User?

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let roles: Set<UserRole> = [realmRole, clientRole]
        userToTest = User(userName: "test", email: "test@example.com", firstName: "First", lastName: "Last", accessToken: "", identityToken: "", roles: roles)
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
}
