import AGSCore
import Apollo
import Foundation

/**
   AeroGear Services sync
 */
public class AgsSync {

    private static let serviceName = "sync"

    public static let instance: AgsSync = {
        let config = AgsCore.instance.getConfiguration(serviceName)
        return AgsSync(config)
    }()

    public var client: ApolloClient?
    public var transport: SyncNetworkTransport?

    init(_ syncConfig: MobileService?) {
        guard let url = syncConfig?.url else {
            AgsCore.logger.error("Sync service is not configured")
            return
        }

        guard let parsedUrl = URL(string: url) else {
            AgsCore.logger.error("Invalid service url provided")
            return
        }

        let configuration = URLSessionConfiguration.default

        self.transport = SyncNetworkTransport(url: parsedUrl, configuration: configuration)
        self.client = ApolloClient(networkTransport: transport!)
    }
}
