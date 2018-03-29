import Foundation

/**
 Model for mobile backend configuration
 */
public struct MobileConfig: Codable {
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
public struct MobileService: Codable {
    /** Unique id for service */
    public let id: String
    public let name: String
    public let type: String
    public let url: String
    public let config: [String: JSONValue]? //we can't use [String:Any] here as it is not conform to the Codable protocol
}

/**
 Represents dynamic values for configuration
 */
public class JSONValue: Codable {
    var rawValue: Any?

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        //the order here is important. An integer can be casted to double, and sometimes vice-versa (e.g 1.0 -> 1). So integer needs to be checked first.
        if let value = try? container.decode(Bool.self) {
            rawValue = value
        } else if let value = try? container.decode(Int.self) {
            rawValue = value
        } else if let value = try? container.decode(Double.self) {
            rawValue = value
        } else if let value = try? container.decode(String.self) {
            rawValue = value
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        if let boolValue = getBool() {
            try container.encode(boolValue)
        } else if let intValue = getInt() {
            try container.encode(intValue)
        } else if let doubleValue = getDouble() {
            try container.encode(doubleValue)
        } else if let stringValue = getString() {
            try container.encode(stringValue)
        }
    }

    /**
     Return the string value
     - returns: a string if the value is a valid string, otherwise nil
     */
    public func getString() -> String? {
        if let stringValue = rawValue as? String {
            return stringValue
        }
        return nil
    }

    /**
     Return the integer value
     - returns: an integer if the value is a valid integer, otherwise nil
     */
    public func getInt() -> Int? {
        if let intValue = rawValue as? Int {
            return intValue
        }
        return nil
    }

    /**
     Return the boolean value
     - returns: a boolean if the value is a valid boolean, otherwise nil
     */
    public func getBool() -> Bool? {
        if let boolValue = rawValue as? Bool {
            return boolValue
        }
        return nil
    }

    /**
     Return the double value
     - returns: a double if the value is a valid double or integer, otherwise nil
     */
    public func getDouble() -> Double? {
        if let doubleValue = rawValue as? Double {
            return doubleValue
        } else if let intValue = rawValue as? Int {
            return Double(intValue)
        }
        return nil
    }
}
