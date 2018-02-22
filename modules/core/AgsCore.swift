import Foundation
import XCGLogger

/**
 * AeroGear Core interface to be used directly by SDK services
 */
public class AgsCore {
    public static let instance: AgsCore = AgsCore()

    let config: ServiceConfig
    let http: AgsHttp
    var metrics: AgsMetrics?

    private init() {
        AgsCore.logger.debug("Initializing AeroGearServices Core SDK")
        config = ServiceConfig()
        http = AgsHttp()
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

    public func getMetricsService() -> AgsMetrics {
        if let metricsInstance = metrics {
            return metricsInstance
        } else {
            metrics = AgsMetrics.init(self)
            return metrics!
        }
    }

    /**
      * Send default app and device metrics including a unique device identifier and
      * App and SDK version information
      */
    public func sendDefaultMetrics() {
        getMetricsService().sendDefaultMetrics()
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
