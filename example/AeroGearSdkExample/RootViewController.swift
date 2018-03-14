import UIKit

class RootViewController: BaseViewController, DrawerMenuDelegate {

    // swiftlint:disable identifier_name
    static let MENU_HOME_TITLE = "Home"
    // swiftlint:disable identifier_name
    static let MENU_AUTHENTICATION_TITLE = "Authentication"
    // swiftlint:disable identifier_name
    static let MENU_PUSH_TITLE = "Push"

    let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        menuDelegate = self
        // Do any additional setup after loading the view.
        addMenuItem(titleOfChildView: RootViewController.MENU_HOME_TITLE, iconName: "ic_home")
        addMenuItem(titleOfChildView: RootViewController.MENU_AUTHENTICATION_TITLE, iconName: "ic_account_circle")
        addMenuItem(titleOfChildView: RootViewController.MENU_PUSH_TITLE, iconName: "ic_notification")
        showFirstChild()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func drawerMenuItemSelectedAtIndex(_ index: Int, _: Bool) {
        if index >= 0 {
            let selectedMenuItem = arrayMenuOptions[index]
            switch selectedMenuItem.title {
            case RootViewController.MENU_HOME_TITLE:
                launchHomeView()
            case RootViewController.MENU_AUTHENTICATION_TITLE:
                launchAuthView()
            case RootViewController.MENU_PUSH_TITLE:
                launchPushView()
            default:
                print("no view to show")
            }
        }
    }

    func launchHomeView() {
        let homeViewController = HomeViewController.loadViewController()
        presentViewController(homeViewController)
    }

    func launchAuthView() {
        let authViewController = AuthViewController.loadViewController()
        presentViewController(authViewController)
    }
    
    func launchPushView() {
        let pushViewController = PushViewController.loadViewController()
        presentViewController(pushViewController)
    }
}
