import AGSCore
import AGSPush
import UIKit

class PushViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    static let pushStoryBoard = UIStoryboard(name: "push", bundle: nil)

    @IBOutlet var tableView: UITableView!

    let notificationCellIdentifier = "PushNotificationCell"

    // holds the messages received and displayed on tableview
    var messages: Array<String> = []

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(PushViewController.messageReceived(_:)), name: Notification.Name(rawValue: "message_received"), object: nil)

        messageReceived(Notification(name: Notification.Name(rawValue: "name"),
                                     userInfo: ["aps": ["alert": "Local push message"]]))
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
            messages.append(pushMessage)
            tableView.reloadData()
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

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: notificationCellIdentifier)!
        cell.textLabel?.text = messages[(indexPath as IndexPath).row]

        return cell
    }
}
