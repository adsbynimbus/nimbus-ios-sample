//
//  GAMInterstitialViewController.swift
//  NimbusInternalSampleApp
//  Created on 1/23/24
//  Copyright © 2024 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import NimbusCoreKit
import NimbusKit
#if canImport(NimbusGAMKit)                    // Swift Package Manager
import NimbusGAMKit
#elseif canImport(NimbusSDK)                   // CocoaPods
import NimbusSDK
#endif
import GoogleMobileAds

class GAMInterstitialViewController: GAMBaseViewController {
    private var interstitialAd: AdManagerInterstitialAd?
    private let gamRequest = AdManagerRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            loadInterstitial(ad: await fetchNimbusBid())
        }
    }
    
    func fetchNimbusBid() async -> Ad? {
        do {
            return try await Nimbus.interstitialAd(position: headerSubTitle).fetch()
        } catch {
            print("Failed fetching Nimbus bid: \(error)")
            return nil
        }
    }
    
    func loadInterstitial(ad: Ad? = nil) {
        ad?.applyDynamicPrice(into: gamRequest, mapping: mapping)
        
        AdManagerInterstitialAd.load(
            with: googleDynamicPricePlacementId,
            request: gamRequest
        ) { [weak self] interstitialAd, error in
            if let error {                
                print("Failed to load dynamic price interstitial ad with error: \(error.localizedDescription)")
                return
            }
            
            guard let self, let interstitialAd else { return }
            
            self.interstitialAd = interstitialAd
            interstitialAd.fullScreenContentDelegate = self
            interstitialAd.appEventDelegate = self
            
            interstitialAd.applyDynamicPrice(ad: ad)
            interstitialAd.present(from: self)
        }
    }
}

// MARK: - GADAppEventDelegate

extension GAMInterstitialViewController: @preconcurrency AppEventDelegate {
    func adView(_ interstitialAd: GoogleMobileAds.InterstitialAd, didReceiveAppEvent name: String, with info: String?) {
        interstitialAd.handleEventForNimbus(name: name, info: info)
    }
}

// MARK: - GADFullScreenContentDelegate

extension GAMInterstitialViewController: FullScreenContentDelegate {
    func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("ad:didFailToPresentFullScreenContentWithError: \(error.localizedDescription)")
    }
    
    func adDidRecordImpression(_ ad: FullScreenPresentingAd) {
        print("adDidRecordImpression")
    }
    
    func adDidRecordClick(_ ad: FullScreenPresentingAd) {
        print("adDidRecordClick")
    }
    
    func adWillPresentFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("ad:adWillPresentFullScreenContent")
    }
    
    func adWillDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("adWillDismissFullScreenContent")
    }
    
    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("adDidDismissFullScreenContent")
    }
}
