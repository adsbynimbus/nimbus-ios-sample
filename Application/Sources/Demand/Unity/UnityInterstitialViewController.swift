//
//  UnityInterstitialViewController.swift
//  Nimbus
//  Created on 1/27/26
//  Copyright © 2026 Nimbus Advertising Solutions Inc. All rights reserved.
//

import NimbusKit
import NimbusUnityKit

class UnityInterstitialViewController: UnityViewController {
    var interstitialAd: InterstitialAd?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task { await showAd() }
    }
    
    func showAd() async {
        do {
            self.interstitialAd = try await Nimbus.fullscreenAd(position: "interstitial") {
                banner(size: .interstitial)
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
