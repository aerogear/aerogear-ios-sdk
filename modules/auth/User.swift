//
//  AgsUser.swift
//  AGSAuth

import Foundation

/**
 Represents the user roles. It has 2 types
 - Realm
 - Client
 
 A user role is a realm role it the nameSpace is not set. Otherwise it is a client role.
 */
struct  UserRole: Hashable {
    /** Supported role types. */
    enum  Types {
        case REALM, CLIENT
    }

    /** namespace of the role. It should be empty or nil for realm roles. Otherwise it should be the client name for a client role */
    let nameSpace: String?
    /** the name of the role **/
    let roleName: String
    /** the type of the role **/
    var roleType: Types {
        get {
            if let ns = nameSpace {
                if (ns.isEmpty) {
                    return Types.REALM
                } else {
                    return Types.CLIENT
                }
            } else {
                return Types.REALM
            }
        }
    }

    var hashValue: Int {
        if let ns = nameSpace {
            return ns.hashValue ^ roleName.hashValue
        } else {
            return roleName.hashValue
        }
    }

    static func == (lhs: UserRole, rhs: UserRole) -> Bool {
        return lhs.nameSpace == rhs.nameSpace && lhs.roleName == rhs.roleName
    }
}

/**
 Represent a user.
 */
public struct User {
    let userName: String
    let email: String
    let accessToken: String
    let identityToken: String
    let roles: Set<UserRole>

    public func hasClientRole(clientName _: String, roleName _: String) -> Bool {
        return false
    }

    public func hasRealmRole(roleName _: String) -> Bool {
        return false
    }
}
