import Foundation
import AGSCore

/**
    AeroGear Services Unified Push SDK
 
    SDK implements registration to Unified Push Server
    in order to corelate mobile clients for sending targeted messages.
 */
public class AgsPush {

    let pushUrlConfig: MobileService;
    
    /**
     Initialise the push module
     
     - parameters:
        - mobileConfig: the configuration for the auth service from the service definition file
     */
    public init(_ mobileConfig: MobileService) {
        self.pushUrlConfig = mobileConfig
    }
    
    /**
       Create DeviceRegistration object in order to register to Unified Push server
     
     - returns: DeviceRegistration object
     */
    public func createDeviceRegistration() -> DeviceRegistration {
        let requestApi = AgsCore.instance.getHttp();
        return DeviceRegistration(URL(string: self.pushUrlConfig.url)!, requestApi);
    }
}
