//
//  AdMobInterstitialViewController.swift
//  NimbusInternalSampleApp
//  Created on 9/11/24
//  Copyright © 2024 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import NimbusKit
import NimbusCoreKit
#if canImport(NimbusSDK) // CocoaPods
import NimbusSDK
#elseif canImport(NimbusAdMobKit) // Swift Package Manager
import NimbusAdMobKit
#endif

private let interstitialPlacementId = Bundle.main.infoDictionary?["AdMob Interstitial ID"] as? String ?? ""

class AdMobInterstitialViewController: AdMobViewController {
    var interstitialAd: InterstitialAd?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            self.interstitialAd = try await Nimbus.fullscreenAd(position: "interstitial") {
                banner(size: .interstitial)
                
                demand {
                    admob(interstitialAdUnitId: interstitialPlacementId)
                }
            }
            .show(in: self)
        }
    }
}
