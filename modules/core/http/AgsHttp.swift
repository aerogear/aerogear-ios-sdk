import AeroGearHttp
import Foundation

public protocol Request {
}

/**
 * Wrapper class used for network requests
 */
public class AgsHttp {

    let defaultHttp = Http()

    public init() {
    }

    /**
     * Return new Http instance for specific service
     */
    public func getHttp(service: MobileService) -> Http {
        return Http(baseURL: service.config?.uri)
    }

    /**
     * Return shared Http instance
     */
    public func getHttp() -> Http {
        return defaultHttp
    }
}
