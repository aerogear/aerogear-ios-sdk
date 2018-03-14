 
import AGSAuth
import AGSCore
 import AGSPush
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_: UIApplication,
                     didFinishLaunchingWithOptions _: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Register with APNs
        UIApplication.shared.registerForRemoteNotifications()
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey: Any] = [:]) -> Bool {
        do {
            return try AgsAuth.instance.resumeAuth(url: url as URL)
        } catch AgsAuth.Errors.serviceNotConfigured {
            print("AeroGear auth service is not configured")
        } catch {
            fatalError("Unexpected error: \(error).")
        }
        return false
    }
    
    
    func applicationWillResignActive(_: UIApplication) {
    }

    func applicationDidEnterBackground(_: UIApplication) {
    }

    func applicationWillEnterForeground(_: UIApplication) {
    }

    func applicationDidBecomeActive(_: UIApplication) {
        AgsCore.instance.getMetrics().sendAppAndDeviceMetrics()
    }

    func applicationWillTerminate(_: UIApplication) {
    }
    
    
    // Handle remote notification registration.
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data){
        AgsCore.logger.info("Registered for notifications with token: \(deviceToken)")
        let notification:Notification = Notification(name: Notification.Name(rawValue: "success_registered"), object: deviceToken)
        NotificationCenter.default.post(notification)
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // The token is not currently available.
        AgsCore.logger.error("Failure to register for notifications: \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // When a message is received, send Notification, would be handled by registered ViewController
        let notification:Notification = Notification(name: Notification.Name(rawValue: "message_received"), object:nil, userInfo:userInfo)
        NotificationCenter.default.post(notification)
        AgsCore.logger.info("Push message recieved: \(userInfo)")
        
        // No additioanl data to fetch
        fetchCompletionHandler(UIBackgroundFetchResult.noData)
    }
    
}
