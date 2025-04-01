//
//  Initialization.swift
//  Sources
//
//  Created on 5/28/23.
//

import AppTrackingTransparency
import NimbusKit
import NimbusRenderStaticKit
import NimbusRenderVASTKit
import SwiftUI
import UIKit
import NimbusVungleKit
import NimbusMobileFuseKit
import NimbusMintegralKit
import NimbusAdMobKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        setupNimbusSDK()
        setupAmazonDemand()
        setupUnityDemand()
        setupMintegralDemand()
        
        // Meta and LiveRamp requires att permissions to run properly
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) { [weak self] in
            self?.startTrackingATT()
            self?.setupMetaDemand()
        }
        
        return true
    }
    
    private func setupNimbusSDK() {
        Nimbus.shared.initialize {
            if let publisher = Bundle.main.infoDictionary?["Publisher Key"] as? String,
               let apiKey = Bundle.main.infoDictionary?["API Key"] as? String {
                credentials(publisher: publisher, apiKey: apiKey)
            }
            
            include(MobileFuseExtension())
            include(MintegralExtension())
            include(AdMobExtension())
            
            if let appId = Bundle.main.infoDictionary?["Vungle App ID"] as? String {
                include(VungleExtension(appId: appId))
            }
        }
        
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
        Nimbus.shared.renderers = [
            .forAuctionType(.static): NimbusStaticAdRenderer(),
            .forAuctionType(.video): NimbusVideoAdRenderer(),
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
