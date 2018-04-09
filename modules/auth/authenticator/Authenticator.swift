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
        - user: the user returned in the `onCompleted` callback function.  Will be nil if authentication failed
        - error: the error returned in the `onCompleted` callback function. Will be nil if authentication was successful
     */
    func authenticate(presentingViewController: UIViewController, onCompleted: @escaping (_ user: User?, _ error: Error?) -> Void)

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
        - error: the error returned in the `onCompleted` callback function. Will be nil if login was successful
    */
    func logout(currentUser: User, onCompleted: @escaping (_ error: Error?) -> Void)
}
