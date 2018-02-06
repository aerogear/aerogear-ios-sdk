import AGSCore
import Foundation

/**
 * AeroGear Services metrics
 */
open class AgsMetrics {

    let core: AgsCore
    let appData: AppData
    let config: MetricsConfig

    var metrics: [Collectable] = Array()

    public init() {
        core = AgsCore()
        appData = AppData()
        config = MetricsConfig(core)

        metrics.append(SdkVersionMetrics(core.getHttp(), config, appData))
    }

    /**
     * Force collect metrics for SDK version
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
