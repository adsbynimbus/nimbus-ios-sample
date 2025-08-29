//
//  MolocoRewardedViewController.swift
//  Nimbus
//  Created on 5/29/25
//  Copyright © 2025 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import NimbusKit
import NimbusCoreKit
#if canImport(NimbusSDK) // CocoaPods
import NimbusSDK
#elseif canImport(NimbusMolocoKit) // Swift Package Manager
import NimbusMolocoKit
#endif

fileprivate var adUnitId = Bundle.main.infoDictionary?["Moloco Rewarded ID"] as! String

final class MolocoRewardedViewController: MolocoViewController {

    private var rewardedAd: RewardedAd?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            self.rewardedAd = try await Nimbus.rewardedAd(position: "rewarded") {
                demand {
                    moloco(adUnitId: adUnitId)
                }
            }
            .show(in: self)
        }
    }
}
