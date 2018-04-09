//
//  AgsUser.swift
//  AGSAuth

import Foundation

/**
 Represents the user roles. It has 2 types
 - Realm
 - Client

 A user role is a realm role if the nameSpace is not set. Otherwise it is a client role.
 */
struct UserRole: Hashable {
    /** Supported role types for UserRole. */
    enum Types {
        case REALM, CLIENT
    }

    /** namespace of the role. It should be empty or nil for realm roles. Otherwise it should be the client name for a client role */
    let nameSpace: String?
    /** the name of the role */
    let roleName: String
    /** the type of the role */
    var roleType: Types {
        if let nspace = nameSpace {
            if nspace.isEmpty {
                return Types.REALM
            } else {
                return Types.CLIENT
            }
        } else {
            return Types.REALM
        }
    }

    var hashValue: Int {
        if let nspace = nameSpace {
            return nspace.hashValue ^ roleName.hashValue
        } else {
            return roleName.hashValue
        }
    }

    static func == (lhs: UserRole, rhs: UserRole) -> Bool {
        return lhs.nameSpace == rhs.nameSpace && lhs.roleName == rhs.roleName
    }
}

/** Describes the structure of user profile returned by Keycloak */
struct KeycloakUserProfile: Codable {
    /** Internal structure for AccessRoles. The JSON object contains other fields but we are only interested in "roles" */
    struct AccessRoles: Codable {
        let roles: [String]?
    }

    private let name: String?
    private let preferredName: String?
    private let realmAccess: AccessRoles?
    private let resourceAccess: [String: AccessRoles]?

    /** first name of Keycloak user */
    let firstName: String?
    /** last name of Keycloak user */
    let lastName: String?
    /** email of Keycloak user */
    let email: String?

    /** The properties used for the `KeycloakUserProfile` representation  */
    enum CodingKeys: String, CodingKey {
        case name
        case preferredName = "preferred_username"
        case email
        case realmAccess = "realm_access"
        case resourceAccess = "resource_access"
        case firstName = "given_name"
        case lastName = "family_name"
    }

    /** Get the name of the user. If `preferred_username` is set, it will be used. Otherwise `name` field will be used */
    var username: String? {
        return preferredName ?? (name ?? nil)
    }

    /** Return all the realm roles of the user */
    var realmRoles: [String] {
        guard let realmData = realmAccess,
            let realmRoles = realmData.roles
        else {
            return [String]()
        }
        return realmRoles
    }

    /**
     Return the client roles of the user.

     - parameters:
         - clientName: the name of the client

     - returns: an array of the role names
    */
    func getClientRoles(_ clientName: String) -> [String] {
        guard let resourceData = resourceAccess,
            let clientData = resourceData[clientName],
            let clientRoles = clientData.roles
        else {
            return [String]()
        }
        return clientRoles
    }

    /**
     Return both realm roles and client roles of the user.

     - parameters:
         - clientName: the name of the client

     - returns: a set of UserRole
     */
    func getUserRoles(forClient clientName: String) -> Set<UserRole> {
        var userRoles = Set<UserRole>()
        for role in realmRoles {
            if !role.isEmpty {
                userRoles.insert(UserRole(nameSpace: nil, roleName: role))
            }
        }
        let clientRoles = getClientRoles(clientName)
        for role in clientRoles {
            if !role.isEmpty {
                userRoles.insert(UserRole(nameSpace: clientName, roleName: role))
            }
        }
        return userRoles
    }
}

/** Represents a user. */
public struct User {
    /** Username */
    public let userName: String?
    /** Email */
    public let email: String?
    /** First Name */
    public let firstName: String?
    /** Last Name */
    public let lastName: String?
    /** Realm roles and client roles of the user */
    var roles: Set<UserRole> = Set<UserRole>()
    /** Realm roles of the user */
    public var realmRoles: [String] {
        let realmRoles = roles.filter({ $0.roleType == UserRole.Types.REALM }).map({ $0.roleName })
        return realmRoles
    }

    /** Client roles of the user */
    public var clientRoles: [String] {
        let clientRoles = roles.filter({ $0.roleType == UserRole.Types.CLIENT }).map({ $0.roleName })
        return clientRoles
    }

    /** Raw value of the access token. Should be used to perform other requests */
    public let accessToken: String?
    /** Identity token */
    public let identityToken: String?
    /** Full Name built using firstName and lastName. If both are not set or empty, nil will be returned */
    public var fullName: String? {
        let name = "\(firstName ?? "") \(lastName ?? "")"
        if name.isEmpty {
            return nil
        }
        return name
    }

    /** Used for testing */
    init(userName: String?, email: String?, firstName: String?, lastName: String?, accessToken: String?, identityToken: String?, roles: Set<UserRole>?) {
        self.userName = userName
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.accessToken = accessToken
        self.identityToken = identityToken
        if let _ = roles {
            self.roles = roles!
        }
    }

    /**
     Build the User instance from the credential data and the Keycloak client name.

     - parameters:
         - credential: the `OIDCCredentials`
         - clientName: the name of the Keycloak client
     */
    init?(credential: OIDCCredentials, clientName: String) {
        guard let token = credential.accessToken,
            let jwt = try? Jwt.decode(token)
        else {
            return nil
        }
        let payload = jwt.payload
        guard let keycloakUserProfile = try? JSONDecoder().decode(KeycloakUserProfile.self, from: payload) else {
            return nil
        }
        accessToken = token
        identityToken = credential.identityToken
        userName = keycloakUserProfile.username
        firstName = keycloakUserProfile.firstName
        lastName = keycloakUserProfile.lastName
        email = keycloakUserProfile.email
        roles = keycloakUserProfile.getUserRoles(forClient: clientName)
    }

    /**
     Check if the user has a client role.

     - parameters:
         - client: name of the client
         - role: name of the role to check

     - returns: true if user has the client role, otherwise false
     */
    public func hasClientRole(client: String, role: String) -> Bool {
        let roleToFind = UserRole(nameSpace: client, roleName: role)
        return roles.contains(roleToFind)
    }

    /**
     Check if the user has a realm role.

     - parameters:
         - roleName: Name of the role

     - returns: true if user has the realm role, otherwise false
     */
    public func hasRealmRole(_ roleName: String) -> Bool {
        let roleToFind = UserRole(nameSpace: nil, roleName: roleName)
        return roles.contains(roleToFind)
    }
}
