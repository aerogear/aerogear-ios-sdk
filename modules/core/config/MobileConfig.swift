import Foundation

/**
 * Model for mobile backend configuration
 */
public struct MobileConfig: Codable {
    // Service namespace
    public var namespace: String?
    // List of services
    public var services = [MobileService]()
}

/**
 * Backend service model containing configuration
 * Represents individual service metadata
 */
public struct MobileService: Codable {
    public var name: String?
    public var config: MobileServiceConfig?
}

/**
 * Service configuration containing both generic and service specific fields.
 */
public struct MobileServiceConfig: Codable {
    public var uri: String?
}
