//
//  APSInterstitialViewController.swift
//  Nimbus
//  Created on 9/5/25
//  Copyright © 2025 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import NimbusCoreKit
import NimbusKit
import DTBiOSSDK
#if canImport(NimbusSDK) // CocoaPods
import NimbusSDK
#elseif canImport(NimbusAPSKit) // Swift Package Manager
import NimbusAPSKit
#endif

class APSInterstitialViewController: SampleAdViewController {
    
    static let apsInterstitialSizes: [DTBAdSize] = [
        .init(interstitialAdSizeWithSlotUUID: "4e918ac0-5c68-4fe1-8d26-4e76e8f74831"),
        .init(videoAdSizeWithSlotUUID: "4acc26e6-3ada-4ee8-bae0-753c1e0ad278")
    ]
    
    var interstitialAd: InterstitialAd?
    private var adLoaders: [DTBAdLoader] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task { await showAd() }
    }
    
    func showAd() async {
        do {
            let customTargeting = await loadAPSInterstitialAds()
            
            self.interstitialAd = try await Nimbus.interstitialAd(position: "interstitial") {
                demand {
                    aps(customTargeting: customTargeting)
                }
            }
            .show(in: self)
        } catch {
            print("Failed to show ad: \(error)")
        }
    }
    
    private func loadAPSInterstitialAds() async -> [[String: String]] {
        for size in Self.apsInterstitialSizes {
            let adLoader = DTBAdLoader(adNetworkInfo: .init(networkName: DTBADNETWORK_NIMBUS))
            adLoader.setAdSizes([size as Any])
            adLoaders.append(adLoader)
        }
        
        return await adLoaders.loadAds()
    }
}
