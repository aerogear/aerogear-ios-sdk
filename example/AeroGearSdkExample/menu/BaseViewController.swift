import UIKit

struct MenuItem {
    let title: String
    let icon: String
}

class BaseViewController: UIViewController {

    var menuDelegate: DrawerMenuDelegate?
    
    var arrayMenuOptions = [MenuItem]()
    
    var menuVC: MenuViewController!
    
    let menuStoryBoard = UIStoryboard(name: "menu", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSlideMenuButton()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func presentViewController(_ subViewNew:UIViewController, _ animated: Bool = true){
        //Add new view
        addChildViewController(subViewNew)
        subViewNew.view.frame = (self.parent?.view.frame)!
        view.addSubview(subViewNew.view)
        subViewNew.didMove(toParentViewController: self)
        
        //Remove old view
        if self.childViewControllers.count > 1 {
            //Remove old view
            let oldViewController: UIViewController = self.childViewControllers.first!
            oldViewController.willMove(toParentViewController: nil)
            oldViewController.view.removeFromSuperview()
            oldViewController.removeFromParentViewController()
        }
    }
    
    func addSlideMenuButton(){
        let navigationBarHeight: CGFloat = self.navigationController!.navigationBar.frame.height
        let btnShowMenu = UIButton(type: UIButtonType.system)
        btnShowMenu.tintColor = UIColor.white
        btnShowMenu.setImage(UIImage(named: "ic_view_headline"), for: UIControlState())
        btnShowMenu.frame = CGRect(x: 0, y: 0, width: navigationBarHeight, height: navigationBarHeight)
        btnShowMenu.addTarget(self, action: #selector(BaseViewController.onSlideMenuButtonPressed(_:)), for: UIControlEvents.touchUpInside)
        let customBarItem = UIBarButtonItem(customView: btnShowMenu)
        self.navigationItem.leftBarButtonItem = customBarItem;
    }
    
    @objc func onSlideMenuButtonPressed(_ sender : UIButton){
        if (sender.tag == 10)
        {
            // To Hide Menu If it already there
            self.menuDelegate?.drawerMenuItemSelectedAtIndex(-1, false);
            
            sender.tag = 0;
            
            menuVC.disappearWithAnimation()
            return
        }
        
        sender.isEnabled = false
        sender.tag = 10
        
        menuVC = menuStoryBoard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menuVC.setMenuItems(arrayMenuOptions)
        menuVC.btnMenu = sender
        menuVC.delegate = self.menuDelegate
        self.view.addSubview(menuVC.view)
        self.addChildViewController(menuVC)
        menuVC.view.layoutIfNeeded()
        menuVC.resizeView()
        menuVC.appearWithAnimation()
        
    }
    
    func addMenuItem(titleOfChildView: String, iconName: String) {
        let menuItem: MenuItem = MenuItem(title: titleOfChildView, icon: iconName)
        arrayMenuOptions.append(menuItem)
    }
    
    func showFirstChild() {
        self.menuDelegate?.drawerMenuItemSelectedAtIndex(0, false)
    }

}
