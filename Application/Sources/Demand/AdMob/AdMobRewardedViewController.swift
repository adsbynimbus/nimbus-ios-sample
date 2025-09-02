//
//  AdMobRewardedViewController.swift
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

private let rewardedPlacementId = Bundle.main.infoDictionary?["AdMob Rewarded ID"] as? String ?? ""

class AdMobRewardedViewController: AdMobViewController {
    var adController: AdController?
    var rewardedAd: RewardedAd?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task { await showAd() }
    }
    
    func showAd() async {
        do {
            self.rewardedAd = try await Nimbus.rewardedAd(position: "rewarded") {
                demand {
                    admob(rewardedAdUnitId: rewardedPlacementId)
                }
            }.show(in: self)
        } catch {
            print("Failed to show ad: \(error)")
        }
    }
}
