//
//  AdMobInterstitialViewController.swift
//  NimbusInternalSampleApp
//  Created on 9/11/24
//  Copyright © 2024 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import NimbusKit
#if canImport(NimbusSDK) // CocoaPods
import NimbusSDK
#elseif canImport(NimbusAdMobKit) // Swift Package Manager
import NimbusAdMobKit
#endif

private let interstitialPlacementId = Bundle.main.infoDictionary?["AdMob Interstitial ID"] as? String ?? ""

class AdMobInterstitialViewController: AdMobViewController {
    var interstitialAd: InterstitialAd?
    
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
            .show(in: self)
        } catch {
            print("Failed to show ad: \(error)")
        }
    }
}
