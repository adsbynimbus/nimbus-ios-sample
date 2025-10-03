//
//  GAMRewardedViewController.swift
//  NimbusInternalSampleApp
//  Created on 1/23/24
//  Copyright © 2024 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import Nimbus
#if canImport(NimbusGAMKit)                    // Swift Package Manager
import NimbusGAMKit
#elseif canImport(NimbusSDK)                   // CocoaPods
import NimbusSDK
#endif
import GoogleMobileAds

class GAMRewardedViewController: GAMBaseViewController {
    private let gamRequest = AdManagerRequest()
    private var rewardedAd: GoogleMobileAds.RewardedAd?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task { loadRewarded(adResponse: await fetchNimbusBid()) }
    }
    
    func fetchNimbusBid() async -> NimbusAd? {
        do {
            return try await Nimbus.rewardedAd(position: headerSubTitle).fetch().response
        } catch {
            print("Failed fetching Nimbus bid: \(error)")
            return nil
        }
    }
    
    func loadRewarded(adResponse: NimbusAd? = nil) {
        adResponse?.applyDynamicPrice(into: gamRequest, mapping: mapping)
        
        RewardedAd.load(
            with: googleDynamicPriceRewardedPlacementId,
            request: gamRequest,
            completionHandler: { [weak self] rewardedAd, error in
                if let error {
                    print("Failed to load rewarded ad with error: \(error.localizedDescription)")
                    return
                }
                
                self?.rewardedAd = rewardedAd
                guard let self, let rewardedAd else { return }
                
                rewardedAd.fullScreenContentDelegate = self
                rewardedAd.adMetadataDelegate = self
                rewardedAd.applyDynamicPrice(adResponse: adResponse)
            }
        )
    }
}

// MARK: - GADFullScreenContentDelegate

extension GAMRewardedViewController: FullScreenContentDelegate {
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

extension GAMRewardedViewController: @preconcurrency AdMetadataDelegate {
    func adMetadataDidChange(_ ad: AdMetadataProvider) {
        rewardedAd?.presentDynamicPrice(from: self, metadataProvider: ad) { adReward in
            print("received reward")
        }
    }
}

// MARK: - NimbusRequestManagerDelegate

extension GAMRewardedViewController: NimbusRequestManagerDelegate {
    func didCompleteNimbusRequest(request: NimbusRequest, ad: NimbusAd) {
        print("didCompleteNimbusRequest")
        
        
    }
    
    func didFailNimbusRequest(request: NimbusRequest, error: NimbusError) {
        print("didFailNimbusRequest: \(error.localizedDescription)")
    }
    
}

