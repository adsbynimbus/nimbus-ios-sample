//
//  AppDelegate.swift
//  nimbus-ios-sample
//
//  Created by Victor Takai on 08/11/21.
//

import UIKit
import SwiftUI
import AppTrackingTransparency

import DTBiOSSDK

import NimbusKit
import NimbusRenderStaticKit
import NimbusRenderVideoKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        setupNimbusSDK()
        setupAmazonDemand()
        setupMetaDemand()
        setupUnityDemand()
        setupVungleDemand()
        
        // Meta and LiveRamp requires att permissions to run properly
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) { [weak self] in
            self?.startTrackingATT()
            self?.setupMetaDemand()
        }
        
        return true
    }

    private func setupNimbusSDK() {
        Nimbus.shared.initialize(
            publisher: Bundle.main.infoDictionary?["Publisher Key"] as! String,
            apiKey: Bundle.main.infoDictionary?["API Key"] as! String
        )
        
        #if DEBUG
        Nimbus.shared.logLevel = .info
        #endif
        Nimbus.shared.testMode = UserDefaults.standard.nimbusTestMode
        Nimbus.shared.coppa = UserDefaults.standard.coppaOn
        
        // This is only for testing environment, do NOT add this on production environment
        if let publisherKey = Nimbus.shared.publisher, Nimbus.shared.testMode {
            NimbusAdManager.requestUrl = URL(string: "https://\(publisherKey).adsbynimbus.com/rta/test")!
            NimbusAdManager.additionalRequestHeaders = [
                "Nimbus-Test-No-Fill": String(UserDefaults.standard.forceNoFill)
            ]
        }
        
        NimbusAdManager.requestInterceptors = []

        // Renderers
        let videoRenderer = NimbusVideoAdRenderer()
        videoRenderer.showMuteButton = true
        videoRenderer.videoAdSettingsProvider = CustomVideoAdSettingsProvider.shared
        Nimbus.shared.renderers = [
            .forAuctionType(.static): NimbusStaticAdRenderer(),
            .forAuctionType(.video): videoRenderer,
        ]

        // User
        NimbusAdManager.user = NimbusUser(age: 20, gender: .male)
    }
    
    private func startTrackingATT() {
        if ATTrackingManager.trackingAuthorizationStatus == .notDetermined {
            var message = ""
            ATTrackingManager.requestTrackingAuthorization {
                switch $0 {
                case .authorized:
                    print("ATT authorized")
                    message = "authorized"
                case .denied:
                    print("ATT denied")
                    message = "denied"
                case .notDetermined:
                    print("ATT notDetermined")
                    message = "notDetermined"
                case .restricted:
                    print("ATT restricted")
                    message = "restricted"
                @unknown default:
                    print("ATT unknown default")
                    message = "unknown default"
                }
                
                DispatchQueue.main.async {
                    Alert.showAlert(
                        title: "Request Tracking Authorization Result",
                        message: message
                    )
                }
            }
        }
    }
}

extension Alert {
    public static func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(
                title: title,
                message: message,
                preferredStyle: .alert
            )
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                NSLog("OK was selected")
            }
            alertController.addAction(okAction)
            
            guard let firstScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let firstWindow = firstScene.windows.first,
                  let viewController = firstWindow.rootViewController else {
                return
            }
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
}
