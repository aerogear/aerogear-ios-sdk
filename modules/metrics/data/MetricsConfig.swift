import AGSCore
import Foundation

struct MetricsConfigData {
}

/**
 * Wrapper used to manage metrics service configuration
 */
class MetricsConfig {

    private let sdkID = "metrics"
    public var config: MobileService?

    init(_ core: AgsCore) {
        if let serviceConfig = core.getConfiguration(sdkID) {
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
     * Checks if configuration contains remote server url
     *
     * @return true if remote metrics should be enabled
     */
    public func remoteMetricsEnabled() -> Bool {
        return config?.url != nil
    }

    /**
     * @return base url for metrics server
     */
    public func getBaseUrl() -> String? {
        return config?.url
    }
}
