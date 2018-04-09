import Foundation

/**
 Model for mobile backend configuration
 */
public struct MobileConfig: Decodable {
    // Version of configuration
    public let version: Int?
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
public struct MobileService: Decodable {
    /** Unique id for service */
    public let id: String
    public let name: String
    public let type: String
    public let url: String
    public let config: [String: JSONValue]? //we can't use [String:Any] here as it is not conform to the Codable protocol

    /**
     Get string with information about mobile service
    */
    public func getDescription() -> String {
        return "id: \(id) \nname: \(name) \nurl: \(url) "
    }
}

extension Optional {
    func resolve(with error: @autoclosure () -> Error) throws -> Wrapped {
        switch self {
        case .none: throw error()
        case let .some(wrapped): return wrapped
        }
    }

    func or(_ other: Optional) -> Optional {
        switch self {
        case .none: return other
        case .some: return self
        }
    }
}

public enum JSONValue: Decodable {
    case string(String)
    case int(Int)
    case bool(Bool)
    case double(Double)
    case object([String: JSONValue])
    case array([JSONValue])

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self = try ((try? container.decode(String.self)).map(JSONValue.string))
            .or((try? container.decode(Int.self)).map(JSONValue.int))
            .or((try? container.decode(Double.self)).map(JSONValue.double))
            .or((try? container.decode(Bool.self)).map(JSONValue.bool))
            .or((try? container.decode([String: JSONValue].self)).map(JSONValue.object))
            .or((try? container.decode([JSONValue].self)).map(JSONValue.array))
            .resolve(with: DecodingError.typeMismatch(JSONValue.self, DecodingError.Context(codingPath: container.codingPath, debugDescription: "Not a JSON")))
    }

    // Fetch string
    public func getString() -> String? {
        switch self {
        case let .string(value):
            return value
        default:
            break
        }
        return nil
    }

    // Fetch Int
    public func getInt() -> Int? {
        switch self {
        case let .int(value):
            return value
        default:
            break
        }
        return nil
    }

    // Fetch Bool
    public func getBool() -> Bool? {
        switch self {
        case let .bool(value):
            return value
        default:
            break
        }
        return nil
    }

    // Fetch object (dictionary)
    public func getObject() -> [String: JSONValue]? {
        switch self {
        case let .object(value):
            return value
        default:
            break
        }
        return nil
    }

    // Fetch Array
    public func getArray() -> [JSONValue]? {
        switch self {
        case let .array(value):
            return value
        default:
            break
        }
        return nil
    }

    // Fetch double
    public func getDouble() -> Double? {
        switch self {
        case let .double(value):
            return value
        case let .int(value):
            return Double(value)
        default:
            break
        }
        return nil
    }
}
