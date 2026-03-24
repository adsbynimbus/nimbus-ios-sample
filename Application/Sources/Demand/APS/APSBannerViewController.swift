//
//  APSBannerViewController.swift
//  Nimbus
//  Created on 9/5/25
//  Copyright © 2025 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import NimbusKit
import DTBiOSSDK
import NimbusAPSKit

class APSBannerViewController: SampleAdViewController {
    
    var bannerAd: InlineAd?
    private var adLoaders: [DTBAdLoader] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task { await showAd() }
    }
    
    func showAd() async {
        do {
            let apsBannerAd = try await loadAPSBannerAd()
            
            self.bannerAd = try await Nimbus.bannerAd(position: "banner", size: .banner, refreshInterval: 30) {
                demand {
                    aps(ads: [apsBannerAd])
                }
            }
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
    
    private func loadAPSBannerAd() async throws -> APSAd {
        let bannerAdRequest = APSAdRequest(
            slotUUID: "88e6293b-0bf0-43fc-947b-925babe7bf3f",
            adNetworkInfo: .init(networkName: .nimbus)
        )
        bannerAdRequest.setAdFormat(.banner)
        
        return try await bannerAdRequest.loadAd()
    }
}
