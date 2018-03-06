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

struct KeycloakUserProfile: Codable {
    private let name: String?
    private let preferredName: String?
    let email: String?
    private let realmAccess: [String: String]?
    private let resourceAccess: [String: [String: String]]?
    
    enum CodingKeys: String, CodingKey {
        case name
        case preferredName = "preferred_username"
        case email
        case realmAccess = "realm_access"
        case resourceAccess = "resource_access"
    }
    
    var username: String {
        return preferredName ?? ( name ?? "UNKNOWN_USERNAME")
    }
    
    var realmRoles: [String] {
        get {
            var realmRolesArr = [String]()
            guard let realmData = realmAccess,
                let realmRoles = realmData["roles"]
            else {
                return realmRolesArr
            }
            let startIndex = realmRoles.index(realmRoles.startIndex, offsetBy: 1)
            let endIndex = realmRoles.index(realmRoles.endIndex, offsetBy: -1)
            let rolesStr = realmRoles[startIndex..<endIndex]
            realmRolesArr = rolesStr.components(separatedBy: ",")
            return realmRolesArr
        }
    }
    
    func getRoles(forClient clientName: String) -> [String] {
        var clientRolesArr = [String]()
        guard  let resourceData = resourceAccess,
            let clientData = resourceData[clientName],
            let clientRoles = clientData["roles"]
        else {
            return clientRolesArr
        }
        let startIndex = clientRoles.index(clientRoles.startIndex, offsetBy: 1)
        let endIndex = clientRoles.index(clientRoles.endIndex, offsetBy: -1)
        let rolesStr = clientRoles[startIndex..<endIndex]
        clientRolesArr = rolesStr.components(separatedBy: ",")
        return clientRolesArr
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
    var roles: Set<UserRole> = Set<UserRole>()
    
    init(userName: String , email: String, accessToken: String, identityToken: String, roles: Set<UserRole>) {
        self.userName = userName
        self.email = email
        self.accessToken = accessToken
        self.identityToken = identityToken
        self.roles = roles
    }
    
    init?(credential: OIDCCredentials, clientName: String) {
        guard let token = credential.getAccessToken(),
            let jwt = try? Jwt.decode(token)
        else {
            return nil
        }
        accessToken = token
        identityToken = credential.getIdentityToken()!
        let payload = jwt.payload
        guard let keycloakUserProfile = try? JSONDecoder().decode(KeycloakUserProfile.self, from: payload) else {
            return nil
        }
        userName = keycloakUserProfile.username
        email = keycloakUserProfile.email!
        let realmRoles = keycloakUserProfile.realmRoles
        for role in realmRoles {
            if !role.isEmpty {
                roles.insert(UserRole(nameSpace: nil, roleName: role))
            }
        }
        let clientRoles = keycloakUserProfile.getRoles(forClient: clientName)
        for role in clientRoles {
            if !role.isEmpty {
                roles.insert(UserRole(nameSpace: clientName, roleName: role))
            }
        }
    }

    public func hasClientRole(client: String, role: String) -> Bool {
        let roleToFind = UserRole(nameSpace: client, roleName: role)
        return roles.contains(roleToFind)
    }

    public func hasRealmRole(_ roleName: String) -> Bool {
        let roleToFind = UserRole(nameSpace: nil, roleName: roleName)
        return roles.contains(roleToFind)
    }
}
