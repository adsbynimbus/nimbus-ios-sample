//
//  AdMobRewardedViewController.swift
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

private let rewardedPlacementId = Bundle.main.infoDictionary?["AdMob Rewarded ID"] as? String ?? ""

class AdMobRewardedViewController: AdMobViewController {
    var adController: AdController?
    let adManager = NimbusAdManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adManager.delegate = self
        adManager.showRewardedAd(
            request: .forRewardedVideo(position: "rewarded"),
            adPresentingViewController: self,
            adMobAdUnitId: rewardedPlacementId
        )
    }
}

extension AdMobRewardedViewController: NimbusAdManagerDelegate {
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
