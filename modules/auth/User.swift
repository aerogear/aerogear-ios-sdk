//
//  AgsUser.swift
//  AGSAuth
//
//  Created by Wei Li on 27/02/2018.
//

import Foundation

/**
 Represents the user roles
 */
struct  UserRole: Hashable {
    /** Possible role types. */
    enum  Types {
        case REALM, CLIENT
    }

    /** namespace of the role. It should be empty or nil for realm roles. Otherwise it should be the client name for a client role */
    let nameSpace: String
    /** the name of the role **/
    let roleName: String
    /** the type of the role **/
    var roleType: Types {
        get {
            if (nameSpace.isEmpty) {
                return Types.REALM
            } else {
                return Types.CLIENT
            }
        }
    }

    var hashValue: Int {
        return nameSpace.hashValue ^ roleName.hashValue
    }

    static func ==(lhs: UserRole, rhs: UserRole) -> Bool {
        return lhs.nameSpace == rhs.nameSpace && lhs.roleName == rhs.roleName
    }
}

/**
 Represent the user
 */
public struct User {
    let userName: String
    let email: String
    let accessToken: String
    let identityToken: String
    let roles: Set<UserRole>

    public func hasClientRole(clientName: String, roleName: String) -> Bool {
        return false
    }

    public func hasRealmRole(roleName: String) -> Bool {
        return false
    }
}
