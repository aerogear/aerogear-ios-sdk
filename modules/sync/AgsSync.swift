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
        let httpInterface = AgsCore.instance.getHttp()
        return AgsSync(config)
    }()

    public var client: ApolloClient?;

    init(_ syncConfig: MobileService?) {
        guard let url = syncConfig?.url else {
            AgsCore.logger.error("Sync service is not configured")
            return;
        }
        
        guard let parsedUrl = URL(string: url) else {
            AgsCore.logger.error("Invalid service url provided")
            return;
        }

        let configuration = URLSessionConfiguration.default
        client = ApolloClient(networkTransport: HTTPNetworkTransport(url: parsedUrl, configuration: configuration))

    }
}
