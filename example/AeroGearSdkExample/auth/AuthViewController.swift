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
        let authenticationConfig = AuthenticationConfig(redirectURL: "org.aerogear.mobile.example:/callback")
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
            guard let currentUser = try AgsAuth.instance.currentUser() else {
                try AgsAuth.instance.login(presentingViewController: self, onCompleted: onLoginComplete)
                return
            }
            onLoginComplete(user: currentUser, err: nil)
        } catch AgsAuth.Errors.serviceNotConfigured {
            showSimpleAlert(title: "Login Error", message: "Auth Service is not configured. Use AgsAuth.instance.configure")
        } catch {
            fatalError("Unexpected error: \(error).")
        }
    }

    func showSimpleAlert(title: String, message: String) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { _ in

        }))
        present(alertView, animated: true, completion: nil)
    }

    func onLoginComplete(user: User?, err: Error?) {
        if let error = err {
            showSimpleAlert(title: "Login Error", message: "Error occurred during login flow \(error)")
            return
        }
        if authDetailsVC == nil {
            authDetailsVC = AuthViewController.authStoryBoard.instantiateViewController(withIdentifier: "AuthenticationDetailsViewController") as? AuthDetailsViewController
        }
        authDetailsVC!.displayUserDetails(from: self, user: user!)
    }

    static func loadViewController() -> UIViewController {
        // TODO: return the right UIViewController based on the current login status
        return authStoryBoard.instantiateViewController(withIdentifier: "AuthenticationViewController")
    }
}
