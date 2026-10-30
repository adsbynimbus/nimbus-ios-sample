//
//  AdMobRewardedViewController.swift
//  NimbusInternalSampleApp
//  Created on 9/11/24
//  Copyright © 2024 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import NimbusKit
import NimbusAdMobKit

private let rewardedPlacementId = Bundle.main.infoDictionary?["AdMob Rewarded ID"] as? String ?? ""

class AdMobRewardedViewController: SampleAdViewController {
    var adController: AdController?
    var rewardedAd: RewardedAd?
    
    convenience init(headerTitle: String, headerSubTitle: String) {
        self.init(
            headerTitle: headerTitle,
            headerSubTitle: headerSubTitle,
            requiredExtension: AdMobExtension.self
        )
    }
    
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
            }
            .onEvent { [weak self] event in
                self?.didReceiveNimbusEvent(event: event, ad: self?.rewardedAd)
            }
            .onError { [weak self] error in
                self?.didReceiveNimbusError(error: error)
            }
            .show(from: self)
        } catch {
            print("Failed to show ad: \(error)")
        }
    }
}
