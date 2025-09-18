//
//  AdMobBannerViewController.swift
//  NimbusInternalSampleApp
//  Created on 9/3/24
//  Copyright © 2024 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import NimbusCoreKit
import NimbusKit
#if canImport(NimbusSDK) // CocoaPods
import NimbusSDK
#elseif canImport(NimbusAdMobKit) // Swift Package Manager
import NimbusAdMobKit
#endif

private let bannerPlacementId = Bundle.main.infoDictionary?["AdMob Banner ID"] as? String ?? ""

class AdMobBannerViewController: AdMobViewController {
    var bannerAd: InlineAd?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task { await showAd() }
    }
    
    func showAd() async {
        do {
            self.bannerAd = try await Nimbus.bannerAd(position: "banner", refreshInterval: 30) {
                demand {
                    admob(bannerAdUnitId: bannerPlacementId)
                }
            }
            .onEvent { [weak self] event in
                self?.didReceiveNimbusEvent(event: event)
            }
            .onError { [weak self] error in
                self?.didReceiveNimbusError(error: error)
            }
            .show(in: view)
        } catch {
            print("Failed to show ad: \(error)")
        }
    }
}
