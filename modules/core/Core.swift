import Foundation

/**
 * Protocol that represents Core SDK API
 */
public protocol AgsCoreServices {
    /**
     * Get configuration for specific service reference
     */
    func getConfiguration(_ serviceRef: String) -> [MobileService]?
}

/**
 * AeroGear Core interface to be used directly by SDK services
 */
public class AgsCore: AgsCoreServices {
    let config: Config

    public init() {
        // TODO: default logger
        config = Config()
    }

    public func getConfiguration(_ serviceRef: String) -> [MobileService]? {
        return config.getConfiguration(serviceRef)
    }
}
