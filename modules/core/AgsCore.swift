import Foundation
import XCGLogger

/**
 * AeroGear Core interface to be used directly by SDK services
 */
public class AgsCore {
    public static let instance: AgsCore = AgsCore()

    let config: ServiceConfig
    let http: AgsHttp
    var metrics: AgsMetrics

    private init() {
        AgsCore.logger.debug("Initializing AeroGearServices Core SDK")
        http = AgsHttp()
        config = ServiceConfig()
        metrics = AgsMetrics(http, config)
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
     *
     * @param
     * @return instance of network interface
     */
    public func getHttp() -> AgsHttpRequest {
        return http.getHttp()
    }

    /**
     * Allows to retrieve metrics protocol to interact with application metrics.
     *
     * @return Metrics protocol to interact with metrics
     * @see AgsCore.sendAppDeviceMetrics helper method
     */
    public func getMetrics() -> MetricsContainer {
        return metrics
    }

    /**
     * Logger instance used for logging across SDK's
     */
    public static var logger: AgsLoggable = {
        let log = XCGLogger(identifier: "AeroGearSDK", includeDefaultDestinations: true)
        log.setup(level: .debug, showThreadName: false, showLevel: true, showFileNames: true, showLineNumbers: true)
        return XCGLoggerAdapter(log)
    }()

    /**
     * Provides way do dynamically change logger implementation
     *
     * @param newLogger - new logger implementation
     */
    public static func setLogger(newLogger: AgsLoggable) {
        logger = newLogger
    }

    /**
     * Returns metadata for SDK including version
     */
    public static func getMetadata() -> AgsMetaData {
        return AppData().metadata
    }
}
