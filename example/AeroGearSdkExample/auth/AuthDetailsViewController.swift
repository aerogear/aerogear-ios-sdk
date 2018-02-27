import UIKit

struct UserIdentity {
    var userName: String = "Unknown Username"
    var fullName: String = "Unknown Name"
    var emailAddress: String = "Unknown Email"
    var reamlRoles: [String] = []
}

class AuthDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var userInfoView: UITableView!

    // TODO: assign the user value after succesfully login
    let testUser = UserIdentity(userName: "John", fullName: "John Doe", emailAddress: "john.doe@example.com", reamlRoles: ["read", "write"])

    var navbarItem: UINavigationItem?
    override func viewDidLoad() {
        super.viewDidLoad()

        userInfoView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showLogoutBtn()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        removeLogoutBtn()
    }

    func removeView() {
        ViewHelper.removeViewController(viewController: self)
    }

    func showLogoutBtn() {
        guard let rootViewController = self.parent?.parent else {
            return
        }
        if rootViewController.isKind(of: RootViewController.self) {
            navbarItem = rootViewController.navigationItem
            navbarItem!.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutTapped))
        }
    }

    func removeLogoutBtn() {
        if navbarItem != nil {
            navbarItem!.rightBarButtonItem = nil
        }
    }

    // TODO: allow pass in the user info
    func displayUserDetails(from: UIViewController) {
        ViewHelper.showChildViewController(parentViewController: from, childViewController: self)
    }

    @IBAction func logoutTapped(_: UIBarButtonItem) {
        let alertView = UIAlertController(title: "Logout", message: "Are you sure to logout?", preferredStyle: UIAlertControllerStyle.alert)
        alertView.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            // TODO: implement logout
            self.removeView()
        }))
        alertView.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in

        }))
        present(alertView, animated: true, completion: nil)
    }

    /*
     // MARK: - tableView datasource delegation
     */
    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return testUser.reamlRoles.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionNum = indexPath.section
        if sectionNum == 0 {
            let userInfoCell = tableView.dequeueReusableCell(withIdentifier: "userInfoCell")!
            let fieldNameLabel = userInfoCell.contentView.viewWithTag(1) as! UILabel
            let fieldValueLabel = userInfoCell.contentView.viewWithTag(2) as! UILabel
            if indexPath.row == 0 {
                fieldNameLabel.text = "Name"
                fieldValueLabel.text = testUser.fullName
            } else {
                fieldNameLabel.text = "Email"
                fieldValueLabel.text = testUser.emailAddress
            }
            return userInfoCell
        } else {
            let roleNameCell = tableView.dequeueReusableCell(withIdentifier: "roleNameCell")!
            let roleValueLabel = roleNameCell.contentView.viewWithTag(1) as! UILabel
            roleValueLabel.text = testUser.reamlRoles[indexPath.row]
            return roleNameCell
        }
    }

    func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "User Details"
        case 1:
            return "Realm Roles"
        default:
            return ""
        }
    }

    func numberOfSections(in _: UITableView) -> Int {
        return 2
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}
