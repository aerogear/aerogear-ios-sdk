//
//  AppDelegate.swift
//  AeroGearSdkExample
//  Copyright © 2018 AeroGear. All rights reserved.
//

import AGSAuth
import AGSCore
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_: UIApplication,
                     didFinishLaunchingWithOptions _: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey: Any] = [:]) -> Bool {
        do {
            return try AgsAuth.instance.resumeAuth(url: url as URL)
        } catch AgsAuth.Errors.serviceNotConfigured {
            print("AeroGear auth service is not configured")
        } catch {
            fatalError("Unexpected error: \(error).")
        }
        return false
    }

    func applicationWillResignActive(_: UIApplication) {
    }

    func applicationDidEnterBackground(_: UIApplication) {
    }

    func applicationWillEnterForeground(_: UIApplication) {
    }

    func applicationDidBecomeActive(_: UIApplication) {
        AgsCore.instance.getMetrics().sendAppAndDeviceMetrics()
    }

    func applicationWillTerminate(_: UIApplication) {
    }
}
