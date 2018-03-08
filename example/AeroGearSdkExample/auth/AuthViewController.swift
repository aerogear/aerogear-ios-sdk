import AGSAuth
import UIKit

class AuthViewController: UIViewController {

    static let authStoryBoard = UIStoryboard(name: "auth", bundle: nil)

    var authVC: UIViewController?
    var authDetailsVC: AuthDetailsViewController?

    @IBOutlet var authenticationButton: UIButton!
    @IBOutlet var logoImage: UIImageView!
    @IBOutlet var backgroundImage: UIImageView!

    override func viewDidLoad() {
        let authenticationConfig = AuthenticationConfig(redirectURL: "org.aerogear.AeroGearSdkExample:/callback")
        AgsAuth.instance.configure(authConfig: authenticationConfig)
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onAuthButtonTapped(_: UIButton) {
        do {
            try AgsAuth.instance.login(presentingViewController: self, onCompleted: onLoginComplete)
        } catch AgsAuth.Errors.serviceNotConfigured {
            showServiceNotConfiguredDialog()
        } catch {
            fatalError("Unexpected error: \(error).")
        }
        // TODO: Remove me once login is properly implemented.
        onLoginComplete(user: nil, err: nil)
    }
    
    func showServiceNotConfiguredDialog() {
        let alertView = UIAlertController(title: "Login Error", message: "Auth Service is not configured. Use AgsAuth.instance.configure", preferredStyle: UIAlertControllerStyle.alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { _ in
            
        }))
        present(alertView, animated: true, completion: nil)
    }
    
    func onLoginComplete(user: User?, err: Error?) {
        print("Login complete")
        if authDetailsVC == nil {
            authDetailsVC = AuthViewController.authStoryBoard.instantiateViewController(withIdentifier: "AuthenticationDetailsViewController") as? AuthDetailsViewController
        }
        authDetailsVC!.displayUserDetails(from: self)
    }

    static func loadViewController() -> UIViewController {
        // TODO: return the right UIViewController based on the current login status
        return authStoryBoard.instantiateViewController(withIdentifier: "AuthenticationViewController")
    }
}
