import UIKit

class AuthViewController: UIViewController {
    
    static let authStoryBoard = UIStoryboard(name: "auth", bundle: nil)
    
    var authVC: UIViewController?
    var authDetailsVC: AuthDetailsViewController?
    
    @IBOutlet weak var authenticationButton: UIButton!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onAuthButtonTapped(_ sender: UIButton) {
        if (self.authDetailsVC == nil) {
            self.authDetailsVC = AuthViewController.authStoryBoard.instantiateViewController(withIdentifier: "AuthenticationDetailsViewController") as? AuthDetailsViewController
        }
        self.authDetailsVC!.displayUserDetails(from: self)
    }
    
    static func loadViewController() -> UIViewController {
        //TODO: return the right UIViewController based on the current login status
        return authStoryBoard.instantiateViewController(withIdentifier: "AuthenticationViewController")
    }
}
