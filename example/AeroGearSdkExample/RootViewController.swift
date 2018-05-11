import UIKit

class RootViewController: BaseViewController, DrawerMenuDelegate {
    // swiftlint:disable identifier_name
    static let MENU_HOME_TITLE = "Home"

    let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        menuDelegate = self
        // Do any additional setup after loading the view.
        addMenuItem(titleOfChildView: RootViewController.MENU_HOME_TITLE, iconName: "ic_home")
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
            default:
                print("no view to show")
            }
        }
    }

    func launchHomeView() {
        let homeViewController = HomeViewController.loadViewController()
        presentViewController(homeViewController)
    }
}
