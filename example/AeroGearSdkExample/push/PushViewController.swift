import AGSPush
import UIKit
import AGSCore
import UserNotifications

class PushViewController: UIViewController, UITableViewDelegate {
    

    static let pushStoryBoard = UIStoryboard(name: "push", bundle: nil)
    
    var deviceToken: Data?;
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // register to be notified when state changes
        NotificationCenter.default.addObserver(self, selector: #selector(PushViewController.registered), name: Notification.Name(rawValue: "success_registered"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PushViewController.messageReceived(_:)), name: Notification.Name(rawValue: "message_received"), object: nil)
    }
    
    @objc func registered(_ notification: Notification) {
        self.deviceToken = notification.object as? Data;
    }
    
    @objc func messageReceived(_ notification: Notification) {
        if let userInfo = notification.userInfo, let aps = userInfo["aps"] as? [String: Any] {
            var pushMessage: String = "No data";
            // if alert is a flat string
            if let msg = aps["alert"] as? String {
                pushMessage = msg;
            } else if let obj = aps["alert"] as? [String: Any], let msg = obj["body"] as? String {
                // if the alert is a dictionary we need to extract the value of the body key
                pushMessage = msg;
            }
            let message = UIAlertController(title: "Push notification recieved!",
                                            message: pushMessage,
                                            preferredStyle: .alert)
            self.present(message, animated:true, completion:nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    static func loadViewController() -> UIViewController {
        return pushStoryBoard.instantiateViewController(withIdentifier: "PushViewController")
    }
    @IBAction func permissionsButtonClicked(_ sender: Any) {
        // Request Permission
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert, .badge]) {
            granted, error in
            if granted {
                print("Approval granted to send notifications")
            } else {
                print(error ?? "")
            }
        }
    }
    
    @IBAction func registerButtonClicked(_ sender: Any) {
        // Ensure that permission button was called
        permissionsButtonClicked([]);
        
        // setup registration
        guard let configuration = AgsCore.instance.getConfiguration("push") else {
            AgsCore.logger.error("Push configuration is missing")
            return;
        }
        
        guard let token = self.deviceToken else {
            AgsCore.logger.error("Push registration token missing")
            return;
        }
        
        let push = AgsPush(configuration)
        let registration = push.createDeviceRegistration();
        // attempt to register
        registration.register(
            clientInfo: { (clientDevice: ClientDeviceInformation!) in
                // setup configuration
                clientDevice.deviceToken = token
                clientDevice.variantID = "01862a41-4d17-45d9-b0ab-5b5047d5d15d"
                clientDevice.variantSecret = "d727538d-af49-4d60-b91d-dc37c1c2011a"
                
                let currentDevice = UIDevice()
                clientDevice.operatingSystem = currentDevice.systemName
                clientDevice.osVersion = currentDevice.systemVersion
                clientDevice.deviceType = currentDevice.model
        },
            success: {
                let message = UIAlertController(title: "Push Registration Success!",
                                                message: "Successfully registered to Unified Push Server.",
                                                preferredStyle: .alert)
                self.present(message, animated:true, completion:nil)
                print("UnifiedPush Server registration succeeded")
        },
            failure: { (error: Error!) in
                let message = UIAlertController(title: "Push Registration Error!",
                                                message: "Please verify the provisionioning profile and the UPS details have been setup correctly.",
                                                preferredStyle:  .alert)
                self.present(message, animated:true, completion:nil)
                print("failed to register for push notifications, error: \(error.localizedDescription)")
        }
        )
    }
    
}
