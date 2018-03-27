import Foundation

/**
   Wrapper class used for network requests
 */
public class AgsHttp {
    let defaultHttp = AgsHttpRequest()

    public init() {
    }

    /**
       Return shared Http instance
     */
    public func getHttp() -> AgsHttpRequest {
        return defaultHttp
    }
}
