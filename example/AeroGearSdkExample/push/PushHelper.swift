import AGSCore
import AGSPush
import Foundation
import UIKit
import UserNotifications

/**
* Contains set of methods used to handle push configuration and messaging.
*/
public class PushHelper {
    /**
      Called when push message was received.
      Presents dialog with message
    */
    public func onPushMessageReceived(_ userInfo: [AnyHashable: Any], _ fetchCompletionHandler: (UIBackgroundFetchResult) -> Void) {
        AgsCore.logger.info("Push message received: \(userInfo)")

        // When a message is received, send Notification, would be handled by registered ViewController
        let notification: Notification = Notification(name: Notification.Name(rawValue: "message_received"), object: nil, userInfo: userInfo)
        NotificationCenter.default.post(notification)

        // No additioanl data to fetch
        fetchCompletionHandler(UIBackgroundFetchResult.noData)
    }

    /**
      Example for AgsPush SDK registration
    */
    public func registerUPS(_ deviceToken: Data) {
        AgsCore.logger.info("Registered for notifications with token")

        let credentials = UnifiedPushCredentials(
                "01862a41-4d17-45d9-b0ab-5b5047d5d15d",
                "d727538d-af49-4d60-b91d-dc37c1c2011a"
        )

        var config = UnifiedPushConfig()
        config.alias = "Example App"
        config.categories = ["iOS", "Example"]

        AgsPush.instance.register(
                deviceToken,
                config,
                credentials,
                success: {
                    AgsCore.logger.info("Successfully registered to Unified Push Server")
                },
                failure: { (error: Error!) in
                    AgsCore.logger.error("Failure to register for on Unified Push Server: \(error)")
                }
        )
    }

    /**
     Initial setup for push notifications

     - registration for remote configuration
     - granting permissions from users
    */
    public func setupPush() {
        UIApplication.shared.registerForRemoteNotifications()
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert, .badge]) {
                granted, error in
                if granted {
                    print("Approval granted to send notifications")
                } else {
                    print(error ?? "")
                }
            }
        } else {
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
    }

    /**
        Called when Apple registration failed
    */
    public func onRegistrationFailed(_ error: Error) {
        AgsCore.logger.error("Failure to register for notifications: \(error)")
    }

}
