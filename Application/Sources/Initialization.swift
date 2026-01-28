//
//  Initialization.swift
//  Sources
//
//  Created on 5/28/23.
//

import AppTrackingTransparency
import NimbusKit
import SwiftUI
import UIKit

#if canImport(NimbusSDK) // CocoaPods
import NimbusSDK
#else                    // Swift Package Manager
import NimbusVungleKit
import NimbusMobileFuseKit
import NimbusMintegralKit
import NimbusAdMobKit
import NimbusMetaKit
import NimbusUnityKit
import NimbusMolocoKit
import NimbusInMobiKit
#endif

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // This is a temporary fix for FBAudienceNetwork 6.17.0+ that crashes trying to read AppDelegate.window
    var window: UIWindow? {
        get {
            let allScenes = UIApplication.shared.connectedScenes
            let scene = allScenes.first { $0.activationState == .foregroundActive } as? UIWindowScene
            return scene?.keyWindow
        }
        set {}
    }
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        setupNimbusSDK()
        setupAmazonDemand()
        
        // Meta and LiveRamp requires att permissions to run properly
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) { [weak self] in
            self?.startTrackingATT()
            self?.setupMetaDemand()
        }
        
        return true
    }
    
    private func setupNimbusSDK() {
        guard let publisher = Bundle.main.infoDictionary?["Publisher Key"] as? String,
           let apiKey = Bundle.main.infoDictionary?["API Key"] as? String else {
            fatalError("Publisher or API Key were not set in Info.plist")
        }
        
        Nimbus.initialize(publisher: publisher, apiKey: apiKey) {
            AdMobExtension()
            MobileFuseExtension()
            MintegralExtension(
                appId: Bundle.main.infoDictionary?["Mintegral App ID"] as? String,
                appKey: Bundle.main.infoDictionary?["Mintegral App Key"] as? String
            )
            MolocoExtension(appKey: Bundle.main.infoDictionary?["Moloco App Key"] as? String)
            InMobiExtension(accountId: Bundle.main.infoDictionary?["InMobi Account ID"] as? String)

            if let appId = Bundle.main.infoDictionary?["Vungle App ID"] as? String {
                VungleExtension(appId: appId)
            }
            
            if let metaNativeId = Bundle.main.infoDictionary?["Meta Native Placement ID"] as? String,
               let metaAppId = metaNativeId.components(separatedBy: "_").first {
                MetaExtension(appId: metaAppId, forceTestAdd: true)
            }
            
            if let gameId = Bundle.main.infoDictionary?["Unity Game ID"] as? String {
                UnityExtension(gameId: gameId)
            }
        }
        
        Nimbus.configuration.testMode = UserDefaults.standard.nimbusTestMode
        Nimbus.configuration.coppa = UserDefaults.standard.coppaOn
        
        // This is only for testing environment, do NOT add this on production environment
        if let mockServerUrl = ProcessInfo.processInfo.environment["MOCK_SERVER_URL"] {
            Nimbus.configuration.requestUrl = URL(string: mockServerUrl)!
        } else if Nimbus.configuration.testMode {
            Nimbus.configuration.requestUrl = URL(string: "https://\(publisher).adsbynimbus.com/rta/test")!
            Nimbus.configuration.additionalRequestHeaders = [
                "Nimbus-Test-No-Fill": String(UserDefaults.standard.forceNoFill)
            ]
        }

        // User
        Nimbus.configuration.user = NimbusUser(age: 20, gender: .male)
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
