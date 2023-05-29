//
//  AppDelegate.swift
//  nimbus-ios-sample
//
//  Created by Jason Sznol on 5/29/23.
//

import Application
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        initializeNimbusSDK()
        return true
    }
}
