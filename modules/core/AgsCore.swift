import Foundation
import XCGLogger

/**
 AeroGear Core SDK
 Internal SDK to be used directly by SDK modules
 */
public class AgsCore {
    public static let instance: AgsCore = AgsCore()

    let config: ServiceConfig
    let http: AgsHttp
    var metrics: AgsMetrics

    public init() {
        AgsCore.logger.debug("Initializing AeroGearServices Core SDK")
        http = AgsHttp()
        config = ServiceConfig()
        metrics = AgsMetrics(http, config)
    }

    /**
     Get single configuration for specific service type

     - returns: MobileService instance or nil if configuration is missing service of that type
     - parameter serviceType:  service type that will be used to fetch configuration
     */
    public func getConfiguration(_ serviceType: String) -> MobileService? {
        let configuration = config.getConfigurationByType(serviceType)
        if configuration.count > 1 {
            AgsCore.logger.warning("""
             Config contains more than one service of the same type.
             Using configuration from the first occurence of service with that type.
            """)
        }
        return configuration.first
    }

    /**
     Get configuration for specific service reference

     - returns: MobileService instance or nil if configuration is missing service of that type
     - parameter serviceId: id that will be used to fetch configuration
     */
    public func getConfigurationById(_ serviceId: String) -> MobileService? {
        return config.getConfigurationById(serviceId)
    }

    /**
     Get instance of http interface

     - returns:  instance of network interface
     */
    public func getHttp() -> AgsHttpRequest {
        return http.getHttp()
    }

    /**
     Allows to retrieve metrics protocol to interact with application metrics.

     - returns:  Metrics protocol to interact with metrics
     */
    public func getMetrics() -> AgsMetrics {
        return metrics
    }

    /**
     Logger instance used for logging across SDK's
     */
    public static var logger: AgsLoggable = {
        let log = XCGLogger(identifier: "AeroGearSDK", includeDefaultDestinations: true)
        log.setup(level: .debug, showThreadName: false, showLevel: true, showFileNames: true, showLineNumbers: true)
        return XCGLoggerAdapter(log)
    }()

    /**
     Provides way do dynamically change logger implementation

     - parameter newLogger: new logger implementation
     */
    public static func setLogger(newLogger: AgsLoggable) {
        logger = newLogger
    }

    /**
     Returns metadata for SDK including version
     */
    public static func getMetadata() -> AgsMetaData {
        return AppData().metadata
    }
}
