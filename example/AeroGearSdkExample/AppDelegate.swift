//
//  AppDelegate.swift
//  AeroGearSdkExample
//  Copyright © 2018 AeroGear. All rights reserved.
//

import AGSMetrics
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_: UIApplication,
                     didFinishLaunchingWithOptions _: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_: UIApplication) {
    }

    func applicationDidEnterBackground(_: UIApplication) {
    }

    func applicationWillEnterForeground(_: UIApplication) {
    }

    func applicationDidBecomeActive(_: UIApplication) {
        AgsMetrics.instance.sendDefaultMetrics()
    }

    func applicationWillTerminate(_: UIApplication) {
    }
}
