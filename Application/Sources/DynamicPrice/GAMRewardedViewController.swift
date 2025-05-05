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
    private lazy var dynamicPriceRenderer: NimbusDynamicPriceRenderer = {
        return NimbusDynamicPriceRenderer(requestManager: requestManager)
    }()
    
    private let gamRequest = AdManagerRequest()
    private var rewardedAd: RewardedAd?
    private var rewardedAdPresenter: NimbusRewardedAdPresenter?
    
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
        
        if let interstitialAd = ad as? InterstitialAd {
            dynamicPriceRenderer.notifyInterstitialLoss(fullScreenPresentingAd: interstitialAd, error: error)
        }
    }
    
    func adDidRecordImpression(_ ad: FullScreenPresentingAd) {
        print("adDidRecordImpression")
        
        if let interstitialAd = ad as? InterstitialAd {
            dynamicPriceRenderer.notifyInterstitialImpression(interstitialAd: interstitialAd)
        }
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
        let isNimbusWin: Bool
        if let rewardedAd {
            isNimbusWin = dynamicPriceRenderer.handleRewardedEventForNimbus(
                adMetadata: ad.adMetadata,
                ad: rewardedAd
            )
        } else {
            isNimbusWin = false
        }
        
        // Show an ad whenever ready
        rewardedAdPresenter?.showAd(
            isNimbusWin: isNimbusWin,
            presentingViewController: self
        )
    }
}

// MARK: - NimbusRewardedAdPresenter

extension GAMRewardedViewController: NimbusRewardedAdPresenterDelegate {
    func didTriggerImpression() {
        print("Rewarded ad impression")
    }
    
    func didTriggerClick() {
        print("Rewarded ad click")
    }
    
    func didPresentAd() {
        print("Rewarded ad presented")
    }
    
    func didCloseAd() {
        print("Rewarded ad closed")
    }
   
    func didEarnReward(reward: AdReward) {
        print("Rewarded ad earned reward")
    }
    
    func didReceiveError(error: NimbusError) {
        print("Rewarded ad error")
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
                rewardedAd.paidEventHandler = { [weak self] adValue in
                    self?.dynamicPriceRenderer.notifyRewardedPrice(
                        adValue: adValue,
                        fullScreenPresentingAd: rewardedAd
                    )
                }
                
                dynamicPriceRenderer.willRender(ad: ad, fullScreenPresentingAd: rewardedAd)
                
                rewardedAdPresenter = NimbusRewardedAdPresenter(
                    request: request,
                    ad: ad,
                    rewardedAd: rewardedAd
                )
                rewardedAdPresenter?.delegate = self
            }
        )
    }
    
    func didFailNimbusRequest(request: NimbusRequestKit.NimbusRequest, error: NimbusCoreKit.NimbusError) {
        print("didFailNimbusRequest: \(error.localizedDescription)")
    }
    
}

