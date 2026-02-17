//
//  UnityBannerViewController.swift
//  Nimbus
//  Created on 1/26/26
//  Copyright © 2026 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import NimbusKit
import NimbusUnityKit

class UnityBannerViewController: UnityViewController {
    var bannerAd: InlineAd?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task { await showAd() }
    }
    
    func showAd() async {
        do {
            self.bannerAd = try await Nimbus.bannerAd(position: "banner", size: .banner, refreshInterval: 30)
                .onEvent { [weak self] event in
                    self?.didReceiveNimbusEvent(event: event, ad: self?.bannerAd)
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
