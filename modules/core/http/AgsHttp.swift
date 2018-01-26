import AeroGearHttp
import Foundation

public protocol Request {
}

/**
 * Wrapper class used for network requests
 */
public class AgsHttp {

    public init() {
    }

    /**
     * Return new Http instance for specific service
     */
    public static func getHttp(service: MobileService) -> Http {
        return Http(baseURL: service.config?.uri)
    }
}
