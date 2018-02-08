import Foundation

/**
 * Contains metadata for SDK
 */
public struct AgsMetaData {

    /** Version of Core SDK */
    // NOTE: This version is being replacted by automation script
    public let sdkVersion = "DEVELOPMENT"

    /** Application installation id */
    public var installationId: String!

    /** Application version */
    public var appVersion: String!

    /**  Application bundle id (org.example.app etc.) */
    public let bundleId: String!
}
