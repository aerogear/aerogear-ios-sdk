import AGSCore
import Foundation

/**
 * AeroGear Services metrics
 */
open class AgsMetrics {

    private let core: AgsCore
    private let appData: AppData
    private let config: MetricsConfig

    public var metrics: [Collectable] = Array()

    public init() {
        core = AgsCore()
        appData = AppData()
        config = MetricsConfig(core)
        enableDefaultMetrics()
    }
    
    /**
     * Method can be extended to initialize specific set of metrics
     */
    open func enableDefaultMetrics(){
       metrics.append(SdkVersionMetrics(core.getHttp(), config, appData))
    }
    
    /**
     * Force collect metrics
     */
    open func collectMetrics() {
        if config.metricsEnabled() {
            for metricsEngine: Collectable in metrics {
                // TODO: Use single URL payload vs metrics sending data to individual URLS.
                metricsEngine.collect()
            }
        }
    }
}
