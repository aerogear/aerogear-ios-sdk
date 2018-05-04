import Foundation

struct MetricsConfigData {
}

/**
 Wrapper used to manage metrics service configuration
 */
class MetricsConfig {
    private let sdkId = "metrics"
    public var config: MobileService?

    init(_ configService: ServiceConfig) {
        let serviceConfigs = configService.getConfigurationByType(sdkId)
        if let serviceConfig = serviceConfigs.first {
            config = serviceConfig
        } else {
            AgsCore.logger.error("""
                Mobile configuration is missing metrics service.
                Metrics will not be enabled
                Please review sdk configuration file.
            """)
        }
    }

    /**
     - Returns: base url for metrics server
     */
    public func getRemoteMetricsUrl() -> String? {
        return config?.url
    }
}
