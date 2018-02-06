import Foundation

/**
 * Model for mobile backend configuration
 */
public struct MobileConfig: Codable {
    // Version of configuration
    public var version: String?
    // Name of the mobile client used to generate this config
    public var client_id: String?
    // Name of the server used to generate configuration
    public var cluster_name: String?
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
    /** Unique id for service */
    public var id: String?
    public var name: String?
    public var type: String?
    public var url: String?
    public var config: [String: ConfigType]?
}

/**
 * Represents dynamic values for configuration
 */
public enum ConfigType: Codable {
    case string(String)
    case bool(Bool)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            self = try .string(container.decode(String.self))
        } catch DecodingError.typeMismatch {
            do {
                self = try .bool(container.decode(Bool.self))
            } catch DecodingError.typeMismatch {
                throw DecodingError.typeMismatch(ConfigType.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Encoded payload not of an expected type"))
            }
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case let .string(string):
            try container.encode(string)
        case let .bool(bool):
            try container.encode(bool)
        }
    }
}
