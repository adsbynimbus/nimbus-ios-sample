//
//  GAMRewardedInterstitialViewController.swift
//  NimbusInternalSampleApp
//  Created on 1/23/24
//  Copyright © 2024 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
#if canImport(NimbusGAMKit)                    // Swift Package Manager
import NimbusGAMKit
#elseif canImport(NimbusSDK)                   // CocoaPods
import NimbusSDK
#endif
import GoogleMobileAds

class GAMRewardedInterstitialViewController: GAMBaseViewController {
    
    private let gamRequest = AdManagerRequest()
    private var rewardedInterstitialAd: RewardedInterstitialAd?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task { loadRewarded(nimbusBid: await fetchNimbusBid()) }
    }
    
    func fetchNimbusBid() async -> NimbusAd? {
        do {
            return try await Nimbus.rewardedAd(position: headerSubTitle).fetchResponse()
        } catch {
            print("Failed fetching Nimbus bid: \(error)")
            return nil
        }
    }
    
    func loadRewarded(nimbusBid: NimbusAd? = nil) {
        nimbusBid?.applyDynamicPrice(into: gamRequest, mapping: mapping)
        
        RewardedInterstitialAd.load(
            with: googleDynamicPriceRewardedPlacementId,
            request: gamRequest
        ) { [weak self] rewardedInterstitialAd, error in
            if let error {
                print("Failed to load rewarded interstitial ad with error: \(error.localizedDescription)")
                return
            }
            
            self?.rewardedInterstitialAd = rewardedInterstitialAd
            guard let self, let rewardedInterstitialAd else { return }
            
            rewardedInterstitialAd.fullScreenContentDelegate = self
            rewardedInterstitialAd.adMetadataDelegate = self
            rewardedInterstitialAd.applyDynamicPrice(ad: nimbusBid)
        }
    }
}

// MARK: - GADFullScreenContentDelegate

extension GAMRewardedInterstitialViewController: FullScreenContentDelegate {
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

// MARK: - GADAdMetadataDelegate

extension GAMRewardedInterstitialViewController: AdMetadataDelegate {
    func adMetadataDidChange(_ ad: AdMetadataProvider) {
        rewardedInterstitialAd?.presentDynamicPrice(from: self, metadataProvider: ad) { adReward in
            print("Received reward")
        }
    }
}

// MARK: - NimbusRequestManagerDelegate

extension GAMRewardedInterstitialViewController: NimbusRequestManagerDelegate {
    func didCompleteNimbusRequest(request: NimbusRequestKit.NimbusRequest, ad: NimbusCoreKit.NimbusAd) {
        print("didCompleteNimbusRequest")
        
        
    }
    
    func didFailNimbusRequest(request: NimbusRequestKit.NimbusRequest, error: NimbusCoreKit.NimbusError) {
        print("didFailNimbusRequest: \(error.localizedDescription)")
    }
    
}
