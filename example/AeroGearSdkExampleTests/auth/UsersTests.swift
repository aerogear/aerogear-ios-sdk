//
//  UsersTests.swift
//  AeroGearSdkExampleTests
//

import XCTest
@testable import AGSAuth

class UsersTests: XCTestCase {
    
    let realmRole: UserRole = UserRole(nameSpace: nil, roleName: "realmRole")
    let clientRole: UserRole = UserRole(nameSpace: "client", roleName: "clientRole")
    var userToTest: User?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let roles: Set<UserRole> = [realmRole, clientRole]
        userToTest = User(userName: "test", email: "test@example.com", accessToken: "", identityToken: "", roles: roles)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testHasRoles() {
        XCTAssertTrue(userToTest!.hasRealmRole("realmRole"))
        XCTAssertTrue(userToTest!.hasClientRole(client: "client", role: "clientRole"))
        XCTAssertFalse(userToTest!.hasRealmRole("wrongRealmRole"))
        XCTAssertFalse(userToTest!.hasClientRole(client: "clientNotExist", role: "clientRole"))
    }
    
}
