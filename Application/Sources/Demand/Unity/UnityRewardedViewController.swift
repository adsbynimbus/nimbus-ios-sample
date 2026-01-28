//
//  UnityRewardedViewController.swift
//  Nimbus
//  Created on 1/27/26
//  Copyright © 2026 Nimbus Advertising Solutions Inc. All rights reserved.
//

import NimbusKit
import NimbusUnityKit

class UnityRewardedViewController: UnityViewController {
    var adController: AdController?
    var rewardedAd: RewardedAd?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task { await showAd() }
    }
    
    func showAd() async {
        do {
            self.rewardedAd = try await Nimbus.rewardedAd(position: "rewarded")
                .onEvent { [weak self] event in
                    self?.didReceiveNimbusEvent(event: event, ad: self?.rewardedAd)
                }
                .onError { [weak self] error in
                    self?.didReceiveNimbusError(error: error)
                }
                .show(in: self)
        } catch {
            print("Failed to show ad: \(error)")
        }
    }
}
