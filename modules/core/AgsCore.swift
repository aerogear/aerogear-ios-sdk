import AeroGearHttp
import Foundation
import XCGLogger

/**
 * AeroGear Core interface to be used directly by SDK services
 */
public class AgsCore {
    public static let instance = AgsCore()

    let config: ServiceConfig

    public init() {
        config = ServiceConfig()
        AgsCoreLogger.logger().debug("Successfully created AeroGearServices SDK")
    }

    /**
     * Get configuration for specific service reference
     * @param serviceRef unique service reference uset to fetch configuration
     * @return MobileService instance or nil if configuration is missing service of that type
     */
    public func getConfiguration(_ serviceRef: String) -> MobileService? {
        return config[serviceRef]
    }

    /**
     * Get instance of http interface
     */
    public func getHttp(_ serviceRef: String) -> Http? {
        if let service = config[serviceRef] {
            return AgsHttp.getHttp(service: service)
        } else {
            return nil
        }
    }

    /**
     * Returns logger instance that can be used to log issues.
     */
    public func logger() -> XCGLogger {
        return AgsCoreLogger.logger()
    }
}
