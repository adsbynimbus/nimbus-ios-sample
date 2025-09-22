//
//  MintegralRewardedViewController.swift
//  Nimbus
//  Created on 11/1/24
//  Copyright © 2024 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import NimbusKit
#if canImport(NimbusSDK) // CocoaPods
import NimbusSDK
#elseif canImport(NimbusMintegralKit) // Swift Package Manager
import NimbusMintegralKit
#endif

class MintegralRewardedViewController: MintegralViewController {
    var rewardedAd: RewardedAd?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task { await showAd() }
    }
    
    func showAd() async {
        do {
            rewardedAd = try await Nimbus.rewardedAd(position: "rewarded") {
                demand {
                    mintegral(adUnitId: "1541935")
                }
            }
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
