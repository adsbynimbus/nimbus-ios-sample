//
//  MobileFuseRewardedViewController.swift
//  NimbusInternalSampleApp
//
//  Created on 9/15/23.
//  Copyright © 2023 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import NimbusKit
import NimbusCoreKit
#if canImport(NimbusSDK) // CocoaPods
import NimbusSDK
#elseif canImport(NimbusMobileFuseKit) // Swift Package Manager
import NimbusMobileFuseKit
#endif

final class MobileFuseRewardedViewController: MobileFuseViewController {
    private var rewardedAd: RewardedAd?
    
    init(headerTitle: String) {
        super.init(headerTitle: headerTitle, headerSubTitle: "")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task { await showAd() }
    }
    
    func showAd() async {
        do {
            rewardedAd = try await Nimbus.rewardedAd(position: "MobileFuse_Testing_Rewarded_iOS_Nimbus")
                .onEvent { [weak self] event in
                    self?.didReceiveNimbusEvent(event: event, ad: self?.rewardedAd)
                }
                .onError { [weak self] error in
                    self?.didReceiveNimbusError(error: error)
                }
                .show(in: self)
        } catch {
            Nimbus.Log.ad.error("Failed to show rewarded ad: \(error.localizedDescription)")
        }
    }
}
