//
//  AdMobBannerViewController.swift
//  NimbusInternalSampleApp
//  Created on 9/3/24
//  Copyright © 2024 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import NimbusKit
#if canImport(NimbusSDK) // CocoaPods
import NimbusSDK
#elseif canImport(NimbusAdMobKit) // Swift Package Manager
import NimbusAdMobKit
#endif

fileprivate let bannerPlacementId = Bundle.main.infoDictionary?["AdMob Banner ID"] as? String ?? ""
fileprivate let interstitialPlacementId = Bundle.main.infoDictionary?["AdMob Interstitial ID"] as? String ?? ""
fileprivate let rewardedPlacementId = Bundle.main.infoDictionary?["AdMob Rewarded ID"] as? String ?? ""
fileprivate let nativePlacementId = Bundle.main.infoDictionary?["AdMob Native ID"] as? String ?? ""

class AdMobBannerViewController: AdMobViewController {
    var adController: AdController?

    let adManager = NimbusAdManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adManager.delegate = self
        adManager.showAd(
            request: .forBannerAd(position: "banner").withAdMob(adUnitId: bannerPlacementId, isBlocking: false),
            container: view,
            adPresentingViewController: self
        )
    }
}

extension AdMobBannerViewController: NimbusAdManagerDelegate {
    func didRenderAd(request: NimbusRequest, ad: NimbusAd, controller: AdController) {
        print("didRenderAd")
        adController = controller
        adController?.delegate = self
        nimbusAd = ad
    }
    
    func didCompleteNimbusRequest(request: NimbusRequest, ad: NimbusAd) {
        print("didCompleteNimbusRequest")
    }
    
    func didFailNimbusRequest(request: NimbusRequest, error: NimbusError) {
        print("didFailNimbusRequest: \(error.localizedDescription)")
    }
}
