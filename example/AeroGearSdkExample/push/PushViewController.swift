import AGSCore
import AGSPush
import UIKit

class PushViewController: UIViewController, UITableViewDelegate {
    static let pushStoryBoard = UIStoryboard(name: "push", bundle: nil)

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(PushViewController.messageReceived(_:)), name: Notification.Name(rawValue: "message_received"), object: nil)
    }

    @objc func messageReceived(_ notification: Notification) {
        if let userInfo = notification.userInfo, let aps = userInfo["aps"] as? [String: Any] {
            var pushMessage: String = "No data"
            // if alert is a flat string
            if let msg = aps["alert"] as? String {
                pushMessage = msg
            } else if let obj = aps["alert"] as? [String: Any], let msg = obj["body"] as? String {
                // if the alert is a dictionary we need to extract the value of the body key
                pushMessage = msg
            }
            let message = UIAlertController(title: "Push notification recieved!",
                                            message: pushMessage,
                                            preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                print("Notification dismissed");
                
            }
            message.addAction(OKAction)
            self.present(message, animated: true, completion: nil)
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
}
