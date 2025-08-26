//
//  GAMRewardedViewController.swift
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

class GAMRewardedViewController: GAMBaseViewController {
    private let requestManager = NimbusRequestManager()
    
    private let gamRequest = AdManagerRequest()
    private var rewardedAd: RewardedAd?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestManager.delegate = self
        requestManager.performRequest(request: NimbusRequest.forRewardedVideo(position: headerSubTitle))
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

extension GAMRewardedViewController: AdMetadataDelegate {
    func adMetadataDidChange(_ ad: AdMetadataProvider) {
        rewardedAd?.presentDynamicPrice(from: self, metadataProvider: ad) { adReward in
            print("received reward")
        }
    }
}

// MARK: - NimbusRequestManagerDelegate

extension GAMRewardedViewController: NimbusRequestManagerDelegate {
    func didCompleteNimbusRequest(request: NimbusRequestKit.NimbusRequest, ad: NimbusCoreKit.NimbusAd) {
        print("didCompleteNimbusRequest")
        
        ad.applyDynamicPrice(into: gamRequest, mapping: mapping)
        
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
                rewardedAd.applyDynamicPrice(ad: ad)
            }
        )
    }
    
    func didFailNimbusRequest(request: NimbusRequestKit.NimbusRequest, error: NimbusCoreKit.NimbusError) {
        print("didFailNimbusRequest: \(error.localizedDescription)")
    }
    
}

