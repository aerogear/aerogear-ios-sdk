import AGSCore
import Apollo
import Foundation
 
 public class MixedNetworkTransport: SyncNetworkTransport {
    private let webSocketNetworkTransport: NetworkTransport
    
    public init(targetUrl: URL) {
        let request = URLRequest(url: targetUrl);
        self.webSocketNetworkTransport = WebSocketTransport(request: request)
        super.init(url: targetUrl)
    }
    
    public override func send<Operation>(operation: Operation, completionHandler: @escaping (GraphQLResponse<Operation>?, Error?) -> Void) -> Cancellable {
        if operation.operationType == .subscription {
            return webSocketNetworkTransport.send(operation: operation, completionHandler: completionHandler)
        } else {
            return super.send(operation: operation, completionHandler: completionHandler)
        }
    }
 }
