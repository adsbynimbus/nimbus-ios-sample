//
//  DTInterstitialViewController.swift
//  Nimbus
//  Created on 5/29/26
//  Copyright © 2025 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import NimbusKit
import NimbusDTKit

final class DTInterstitialViewController: DTViewController {

    private var interstitialAd: InterstitialAd?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task { await showAd() }
    }
    
    func showAd() async {
        do {
            interstitialAd = try await Nimbus.interstitialAd(position: "interstitial")
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
