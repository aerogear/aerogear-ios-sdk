import Foundation
import UIKit

class ViewHelper {
    class func showChildViewController(parentViewController parent: UIViewController, childViewController child: UIViewController) {
        parent.addChildViewController(child)
        child.view.frame = parent.view.bounds
        parent.view.addSubview(child.view)
        child.didMove(toParentViewController: parent)
    }
    
    class func removeViewController(viewController: UIViewController) {
        viewController.willMove(toParentViewController: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }
}
