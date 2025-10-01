//
//  InMobiRewardedViewController.swift
//  Nimbus
//  Created on 7/31/25
//  Copyright © 2025 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import NimbusKit
#if canImport(NimbusSDK) // CocoaPods
import NimbusSDK
#else                    // Swift Package Manager
import NimbusInMobiKit
#endif

fileprivate var placementId = Int(Bundle.main.infoDictionary?["InMobi Rewarded ID"] as! String)!

final class InMobiRewardedViewController: InMobiViewController {

    private var rewardedAd: RewardedAd?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            self.rewardedAd = try await Nimbus.rewardedAd(position: "rewarded") {
                demand {
                    inmobi(placementId: placementId)
                }
            }
            .onEvent { [weak self] event in
                self?.didReceiveNimbusEvent(event: event, ad: self?.rewardedAd)
            }
            .onError { [weak self] error in
                self?.didReceiveNimbusError(error: error)
            }
            .show(in: self)
        }
    }
}
