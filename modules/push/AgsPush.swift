import Foundation
import AGSCore

/**
    AeroGear Services Unified Push SDK
 
    SDK implements registration to Unified Push Server
    in order to corelate mobile clients for sending targeted messages.
 */
public class AgsPush {

    private static let serviceName = "push";
    public static let instance: AgsPush = AgsPush(AgsCore.instance.getConfiguration(serviceName));
    
    let pushUrlConfig: MobileService?;
    
    /**
     Initialise the push module
     
     - parameters:
        - mobileConfig: the configuration for the auth service from the service definition file
     */
    private init(_ mobileConfig: MobileService?) {
        self.pushUrlConfig = mobileConfig
    }
    
    /**
       Create DeviceRegistration object in order to register to Unified Push server
     
     - returns: DeviceRegistration object or nil if service is not configured
     */
    public func createDeviceRegistration() -> DeviceRegistration? {
        guard let config = self.pushUrlConfig else {
            return nil;
        }
        let requestApi = AgsCore.instance.getHttp();
        return DeviceRegistration(URL(string: config.url)!, requestApi);
    }
}
