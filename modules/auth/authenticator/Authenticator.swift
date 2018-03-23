//
//  Authenticator.swift
//  AGSAuth

import Foundation

/** Interface for authentication actions like login and logout. */
public protocol Authenticator {
    /**
     Performs the login operation.
     
     - parameters:
        - presentingViewController: the view controller
        - onCompleted: callback function that is invoked when the login is completed
     */
    func authenticate(presentingViewController: UIViewController, onCompleted: @escaping (User?, Error?) -> Void)
    
    /**
     Resumes the login operation.
     
     - parameters:
        - url: the redirect url used to redirect back to the app after a
            login attempt via the device browser
     
     - returns: true if the login action can be resumed, false otherwise
    */
    func resumeAuth(url: URL) -> Bool
    
    /**
     Performs the logout operation.
     
     - parameters:
        - currentUser: the user to be logged out
        - onCompleted: callback function that is invoked when the logout is completed
    */
    func logout(currentUser: User, onCompleted: @escaping (Error?) -> Void)
}
