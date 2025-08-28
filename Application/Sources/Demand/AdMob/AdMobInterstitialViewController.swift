//
//  AdMobInterstitialViewController.swift
//  NimbusInternalSampleApp
//  Created on 9/11/24
//  Copyright © 2024 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import NimbusKit
#if canImport(NimbusSDK) // CocoaPods
import NimbusSDK
#elseif canImport(NimbusAdMobKit) // Swift Package Manager
import NimbusAdMobKit
#endif

private let interstitialPlacementId = Bundle.main.infoDictionary?["AdMob Interstitial ID"] as? String ?? ""

class AdMobInterstitialViewController: AdMobViewController {
    var adController: AdController?
    let adManager = NimbusAdManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var request = NimbusRequest
            .forInterstitialAd(position: "interstitial")
            .withAdMobInterstitial(adUnitId: interstitialPlacementId)
        request.impressions[0].video = nil
        
        adManager.delegate = self
        adManager.showBlockingAd(request: request, adPresentingViewController: self)
    }
}

extension AdMobInterstitialViewController: NimbusAdManagerDelegate {
    func didRenderAd(request: NimbusRequest, ad: NimbusAd, controller: AdController) {
        print("didRenderAd")
        adController = controller
        adController?.register(delegate: self)
        nimbusAd = ad
    }
    
    func didCompleteNimbusRequest(request: NimbusRequest, ad: NimbusAd) {
        print("didCompleteNimbusRequest")
    }
    
    func didFailNimbusRequest(request: NimbusRequest, error: NimbusError) {
        print("didFailNimbusRequest: \(error.localizedDescription)")
    }
}
