//
//  Authenticator.swift
//  AGSAuth

import Foundation

public protocol Authenticator {
    func authenticate(presentingViewController: UIViewController, onCompleted: @escaping (User?, Error?) -> Void)
    func logout(currentUser: User, onCompleted: @escaping (Error?) -> Void)
}
