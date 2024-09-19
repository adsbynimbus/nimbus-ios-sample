//
//  AppDelegate.swift
//  AdMobUIKitSample
//  Created on 9/19/24
//  Copyright © 2024 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import NimbusKit
import NimbusSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        Nimbus.shared.initialize(publisher: "dev-sdk", apiKey: "d352cac1-cae2-4774-97ba-4e15c6276be0")

        Nimbus.shared.logLevel = .info
        Nimbus.shared.testMode = true
        
        if let publisherKey = Nimbus.shared.publisher, Nimbus.shared.testMode {
            NimbusAdManager.requestUrl = URL(string: "https://\(publisherKey).adsbynimbus.com/rta/test")!
        }
        
        Nimbus.shared.renderers[.forNetwork("admob")] = NimbusAdMobAdRenderer()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

