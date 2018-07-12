import Foundation
import AGSCore
import Apollo

/**
   AeroGear Services sync
 */
public class AgsSync {
    
    private let serviceName = "sync"
    
    public static let instance: AgsSync = {
        let config = AgsCore.instance.getConfiguration(serviceName)
        let httpInterface = AgsCore.instance.getHttp()
        return AgsSync(config)
    }()
   
    public static let instance = SyncService()
 
    public let client: ApolloClient

    init(_ mobileConfig: MobileService?) {
        self.serviceConfig = mobileConfig
        
        guard let url = mobileConfig.url else {
            return AgsCore.logger.error("Sync service is not configured");
        }
  
        let configuration = URLSessionConfiguration.default
        let url = URL(string: url)!
        client = ApolloClient(networkTransport: HTTPNetworkTransport(url: url, configuration: configuration))
        client.cacheKeyForObject = { $0["id"] }
    }
}
