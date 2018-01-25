import Foundation

/**
 * AeroGear Core interface to be used directly by SDK services
 */
public class AgsCore {
    public static let instance = AgsCore()

    let config: Config

    public init() {
        config = Config()
        AgsCoreLogger.logger().debug("Successfully intialized SDK")
    }

    /**
     * Get configuration for specific service reference
     */
    public func getConfiguration(_ serviceRef: String) -> [MobileService] {
        return config[serviceRef]
    }

    public func getLogger() {
    }
}
