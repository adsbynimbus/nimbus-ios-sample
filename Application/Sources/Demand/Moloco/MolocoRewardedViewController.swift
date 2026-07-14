//
//  MolocoRewardedViewController.swift
//  Nimbus
//  Created on 5/29/25
//  Copyright © 2025 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import NimbusKit
import NimbusMolocoKit

final class MolocoRewardedViewController: SampleAdViewController {

    private var rewardedAd: RewardedAd?
    
    convenience init(headerTitle: String, headerSubTitle: String) {
        self.init(
            headerTitle: headerTitle,
            headerSubTitle: headerSubTitle,
            requiredExtension: MolocoExtension.self
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            self.rewardedAd = try await Nimbus.rewardedAd(position: "rewarded")
                .onEvent { [weak self] event in
                    self?.didReceiveNimbusEvent(event: event, ad: self?.rewardedAd)
                }
                .onError { [weak self] error in
                    self?.didReceiveNimbusError(error: error)
                }
                .show(from: self)
        }
    }
}
