//
//  Initialization.swift
//  Sources
//
//  Created on 5/28/23.
//

import AppTrackingTransparency
import NimbusKit
import NimbusRenderStaticKit
import NimbusRenderVideoKit
import SwiftUI
import UIKit

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
        setupAdMobDemand()
        setupMobileFuseDemand()
        setupAmazonDemand()
        setupUnityDemand()
        setupVungleDemand()
        setupMintegralDemand()
        setupMolocoDemand()
        
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
        if let mockServerUrl = ProcessInfo.processInfo.environment["MOCK_SERVER_URL"] {
            NimbusAdManager.requestUrl = URL(string: mockServerUrl)!
        } else if let publisherKey = Nimbus.shared.publisher, Nimbus.shared.testMode {
            NimbusAdManager.requestUrl = URL(string: "https://\(publisherKey).adsbynimbus.com/rta/test")!
            NimbusAdManager.additionalRequestHeaders = [
                "Nimbus-Test-No-Fill": String(UserDefaults.standard.forceNoFill)
            ]
        }
        
        NimbusAdManager.requestInterceptors = []

        // Renderers
        let videoRenderer = NimbusVideoAdRenderer()
        videoRenderer.showMuteButton = true
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
