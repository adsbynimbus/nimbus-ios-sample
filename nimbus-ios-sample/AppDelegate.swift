//
//  AppDelegate.swift
//  nimbus-ios-sample
//
//  Created by Victor Takai on 08/11/21.
//

import UIKit

import NimbusKit
import NimbusRequestAPSKit
import NimbusRenderStaticKit
import NimbusRenderVideoKit
import NimbusRenderOMKit

import FBAudienceNetwork
import MoPubSDK
import GoogleMobileAds

import AppTrackingTransparency

#if canImport(NimbusSDK)
import NimbusSDK
#endif

#if canImport(NimbusRenderFANKit)
import NimbusRenderFANKit
#endif

#if canImport(NimbusUnityKit)
import NimbusUnityKit
#endif

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupNimbusSDK()
        setupFAN()
        setupMopub()
        setupGAM()
        
        return true
    }

    private func setupNimbusSDK() {
        Nimbus.shared.initialize(
            publisher: ConfigManager.shared.publisherKey,
            apiKey: ConfigManager.shared.apiKey
        )
        
        // This is only for testing environment, do NOT add this on production environment
        let url = URL(string: "https://dev-sdk.adsbynimbus.com/rta/test")!
        NimbusAdManager.requestUrl = url
        NimbusAdManager.additionalRequestHeaders = [
            "Nimbus-Test-No-Fill": String(UserDefaults.standard.forceNoFill)
        ]
        
        #if DEBUG
        Nimbus.shared.logLevel = .info
        #endif
        Nimbus.shared.testMode = UserDefaults.standard.nimbusTestMode
        Nimbus.shared.coppa = UserDefaults.standard.coppaOn

        NimbusAdManager.demandProviders = []
        
        // Demand Providers
        if let aps = DemoDemandProviders.shared.aps {
            NimbusAdManager.demandProviders?.append(aps)
        }
                        
        // Renderers
        let videoRenderer = NimbusVideoAdRenderer()
        videoRenderer.showMuteButton = true
        Nimbus.shared.renderers = [
            .forAuctionType(.static): NimbusStaticAdRenderer(),
            .forAuctionType(.video): videoRenderer,
            .forNetwork("facebook"): NimbusFANAdRenderer(),
            .forNetwork("unity"): NimbusUnityAdRenderer()
        ]

        // User
        var user = NimbusUser(age: 20, gender: .male)
        user.configureGdprConsent(didConsent: UserDefaults.standard.gdprConsent)
        NimbusAdManager.user = user
        
        // OM Viewability initialization
        // Verification providers can be added here
        // OMID flag can be turned ON (example in the Settings)
        Nimbus.shared.viewabilityProvider = .init(
            builder: NimbusAdViewabilityTrackerBuilder(verificationProviders: nil)
        )
    }

    private func setupFAN() {
        FBAdSettings.addTestDevice(FBAdSettings.testDeviceHash())
        if ATTrackingManager.trackingAuthorizationStatus == .notDetermined {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { _ in () })
        }
        // Required for test ads
        FBAdSettings.setAdvertiserTrackingEnabled(true)
    }
    
    private func setupMopub() {
        guard let mopubBannerId = ConfigManager.shared.mopubBannerId,
            !mopubBannerId.isEmpty else {
            return
        }
        let config = MPMoPubConfiguration(adUnitIdForAppInitialization: mopubBannerId)
        #if DEBUG
        config.loggingLevel = .debug
        #endif
        MoPub.sharedInstance().initializeSdk(with: config, completion: nil)
    }

    private func setupGAM() {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
    }
}

