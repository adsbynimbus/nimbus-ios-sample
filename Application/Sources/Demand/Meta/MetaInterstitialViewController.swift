//
//  MetaInterstitialViewController.swift
//  Nimbus
//  Created on 1/28/26
//  Copyright © 2026 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import NimbusKit
import NimbusMetaKit

class MetaInterstitialViewController: SampleAdViewController {
    var interstitialAd: InterstitialAd?
    
    convenience init(headerTitle: String, headerSubTitle: String) {
        self.init(
            headerTitle: headerTitle,
            headerSubTitle: headerSubTitle,
            requiredExtension: MetaExtension.self
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task { await showAd() }
    }
    
    func showAd() async {
        do {
            self.interstitialAd = try await Nimbus.interstitialAd(position: "interstitial")
                .onEvent { [weak self] event in
                    self?.didReceiveNimbusEvent(event: event, ad: self?.interstitialAd)
                }
                .onError { [weak self] error in
                    self?.didReceiveNimbusError(error: error)
                }
                .show(from: self, closeButtonDelay: 0)
        } catch {
            Nimbus.Log.ad.error("Failed to show interstitial ad: \(error.localizedDescription)")
        }
    }
}
