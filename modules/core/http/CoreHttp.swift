import AeroGearHttp
import Foundation

public protocol Request {
}

/**
 * Main interface for http handling
 */
public class CoreHttp {
    var http: Http

    public init(service: MobileService) {
        // Depending on mobile service configuration more elements can be added
        http = Http(baseURL: service.config?.uri)
    }

    func request() {
    }
}
