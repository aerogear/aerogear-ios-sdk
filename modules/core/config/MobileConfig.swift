import Foundation

/**
 Model for mobile backend configuration
 */
public struct MobileConfig: Codable {
    // Version of configuration
    public let version: String?
    // Name of the mobile client used to generate this config
    public let clientId: String?
    // Name of the server used to generate configuration
    public let clusterName: String?
    // Service namespace
    public let namespace: String?
    // List of services
    public let services: [MobileService]
}

/**
 Backend service model containing configuration
 Represents individual service metadata
 */
public struct MobileService: Codable {
    /** Unique id for service */
    public let id: String?
    public let name: String?
    public let type: String?
    public let url: String?
    public let config: [String: ConfigType]?
}

/**
 Represents dynamic values for configuration
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
                let decodingError = DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Encoded payload not of an expected type")
                throw DecodingError.typeMismatch(ConfigType.self, decodingError)
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
