//
//  APSInterstitialViewController.swift
//  Nimbus
//  Created on 9/5/25
//  Copyright © 2025 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import NimbusKit
@preconcurrency import DTBiOSSDK
import NimbusAPSKit

class APSInterstitialViewController: SampleAdViewController {
    
    var interstitialAd: InterstitialAd?
    private var adLoaders: [DTBAdLoader] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task { await showAd() }
    }
    
    func showAd() async {
        do {
            let ads = await loadAPSInterstitialAds()
            self.interstitialAd = try await Nimbus.interstitialAd(position: "interstitial") {
                demand {
                    aps(ads: ads)
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
    
    private func loadAPSInterstitialAds() async -> [APSAd] {
        let interstitialAdRequest = APSAdRequest(
            slotUUID: "424c37b6-38e0-4076-94e6-0933a6213496",
            adNetworkInfo: .init(networkName: .nimbus)
        )
        interstitialAdRequest.setAdFormat(.interstitial)
        
        let videoAdRequest = APSAdRequest(
            slotUUID: "671086df-06f2-4ee7-86f6-e578d10b3128",
            adNetworkInfo: .init(networkName: .nimbus)
        )
        videoAdRequest.setAdFormat(.interstitial)
        
        let requests = [
            interstitialAdRequest,
            videoAdRequest
        ]
        
        return await withTaskGroup(of: APSAd?.self) { group in
            for request in requests {
                group.addTask {
                    do {
                        return try await request.loadAd()
                    } catch {
                        print("Couldn't fetch APS ad, error: \(error.localizedDescription)")
                        return nil
                    }
                }
            }
            
            var ads: [APSAd] = []

            for await ad in group {
                if let ad { ads.append(ad) }
            }

            return ads
        }
    }
}
