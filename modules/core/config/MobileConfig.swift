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
 */
public struct MobileService: Codable {
    public var name: String?
    public var config: ServiceConfig?
}

/**
 * Service configuration
 */
public struct ServiceConfig: Codable {
    public var uri: String?
}
