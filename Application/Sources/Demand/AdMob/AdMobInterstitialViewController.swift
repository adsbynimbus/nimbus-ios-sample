//
//  AdMobInterstitialViewController.swift
//  NimbusInternalSampleApp
//  Created on 9/11/24
//  Copyright © 2024 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import NimbusKit
import NimbusAdMobKit

private let interstitialPlacementId = Bundle.main.infoDictionary?["AdMob Interstitial ID"] as? String ?? ""

class AdMobInterstitialViewController: SampleAdViewController {
    var interstitialAd: FullscreenAd?
    
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
            self.interstitialAd = try await Nimbus.fullscreenAd(position: "interstitial") {
                banner(size: .interstitial)
                
                demand {
                    admob(interstitialAdUnitId: interstitialPlacementId)
                }
            }
            .onEvent { [weak self] event in
                self?.didReceiveNimbusEvent(event: event, ad: self?.interstitialAd)
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
