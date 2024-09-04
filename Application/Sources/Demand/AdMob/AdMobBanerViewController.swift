//
//  AdMobBanerViewController.swift
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

class AdMobBanerViewController: DemoViewController {

    let adManager = NimbusAdManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        adManager.showAd(
            request: .forBannerAd(position: "pos").withAdMob(adUnitId: bannerPlacementId, isBlocking: false),
            container: view,
            adPresentingViewController: self)
    }

}
