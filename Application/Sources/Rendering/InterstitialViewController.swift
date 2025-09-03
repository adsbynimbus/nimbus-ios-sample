//
//  InterstitialViewController.swift
//  Nimbus
//  Created on 9/2/25
//  Copyright © 2025 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import NimbusKit

final class InterstitialViewController: SampleAdViewController {
    var interstitialAd: InterstitialAd?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task { await showAd() }
    }
    
    func showAd() async {
        do {
            interstitialAd = try await Nimbus.interstitialAd(position: "interstitial")
                .onEvent { event in
                    print("Received Nimbus event: \(event)")
                }
                .onError { error in
                    print("Received Nimbus error: \(error)")
                }
                .show(in: self)
        } catch {
            print("Couldn't show ad: \(error)")
        }
    }
}
