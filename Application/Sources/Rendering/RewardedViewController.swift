//
//  RewardedViewController.swift
//  Nimbus
//  Created on 9/2/25
//  Copyright © 2025 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import NimbusKit

final class RewardedViewController: SampleAdViewController {
    var rewardedAd: RewardedAd?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task { await showAd() }
    }
    
    func showAd() async {
        do {
            rewardedAd = try await Nimbus.rewardedAd(position: "rewarded")
                .onEvent { [weak self] event in
                    self?.didReceiveNimbusEvent(event: event)
                }
                .onError { [weak self] error in
                    self?.didReceiveNimbusError(error: error)
                }
                .show()
        } catch {
            print("Couldn't show ad: \(error)")
        }
    }
}
