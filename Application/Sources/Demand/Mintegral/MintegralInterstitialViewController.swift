//
//  MintegralInterstitialViewController.swift
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

class MintegralInterstitialViewController: MintegralViewController {
    var interstitialAd: InterstitialAd?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task { await showAd() }
    }
    
    func showAd() async {
        do {
            self.interstitialAd = try await Nimbus.interstitialAd(position: "interstitial") {
                demand {
                    mintegral(adUnitId: "1541952")
                }
            }
            .onEvent { [weak self] event in
                self?.didReceiveNimbusEvent(event: event, ad: self?.interstitialAd)
            }
            .onError { [weak self] error in
                self?.didReceiveNimbusError(error: error)
            }
            .show(in: self, closeButtonDelay: 0)
        } catch {
            Nimbus.Log.ad.error("Failed to show interstitial ad: \(error.localizedDescription)")
        }
    }
}
