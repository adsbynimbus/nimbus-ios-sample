//
//  APSBannerViewController.swift
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

class APSBannerViewController: SampleAdViewController {
    
    static let apsBannerSizes: [DTBAdSize] = [
        .init(bannerAdSizeWithWidth: 320, height: 50, andSlotUUID: "5ab6a4ae-4aa5-43f4-9da4-e30755f2b295")
    ]
    
    var bannerAd: InlineAd?
    private var adLoaders: [DTBAdLoader] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task { await showAd() }
    }
    
    func showAd() async {
        do {
            let tokenData = await loadAPSBannerAds()
            
            self.bannerAd = try await Nimbus.bannerAd(position: "banner", refreshInterval: 30) {
                demand {
                    aps(tokenData: tokenData, adLoaders: adLoaders)
                }
            }
            .show(in: view)
        } catch {
            print("Failed to show ad: \(error)")
        }
    }
    
    private func loadAPSBannerAds() async -> [[String: String]] {
        for size in Self.apsBannerSizes {
            let adLoader = DTBAdLoader(adNetworkInfo: .init(networkName: DTBADNETWORK_NIMBUS))
            adLoader.setAdSizes([size as Any])
            adLoaders.append(adLoader)
        }
        
        return await adLoaders.loadAds()
    }
}
