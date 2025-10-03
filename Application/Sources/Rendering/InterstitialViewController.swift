//
//  InterstitialViewController.swift
//  Nimbus
//  Created on 9/2/25
//  Copyright © 2025 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import Nimbus

final class InterstitialViewController: SampleAdViewController {
    var interstitialAd: InterstitialAd?
    
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
                .show(in: self, closeButtonDelay: 0)
        } catch {
            print("Couldn't show ad: \(error)")
        }
    }
}
