import Foundation

/**
   Contains metadata for SDK
 */
public struct AgsMetaData {
    /** Version of Core SDK */
    // NOTE: This version is being replacted by automation script
    public let sdkVersion = "1.0.0-alpha.2"

    /** Unique client id */
    public var clientId: String!

    /** Application version */
    public var appVersion: String!

    /**  Application bundle id (org.example.app etc.) */
    public let bundleId: String!
}
