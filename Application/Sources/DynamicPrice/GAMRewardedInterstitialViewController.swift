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
    private let requestManager = NimbusRequestManager()
    private lazy var dynamicPriceRenderer: NimbusDynamicPriceRenderer = {
        return NimbusDynamicPriceRenderer(requestManager: requestManager)
    }()
    
    private let gamRequest = AdManagerRequest()
    private var rewardedInterstitialAd: RewardedInterstitialAd?
    private var rewardedAdPresenter: NimbusRewardedAdPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestManager.delegate = self
        requestManager.performRequest(request: NimbusRequest.forRewardedVideo(position: headerSubTitle))
    }
}

// MARK: - GADFullScreenContentDelegate

extension GAMRewardedInterstitialViewController: FullScreenContentDelegate {
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

extension GAMRewardedInterstitialViewController: AdMetadataDelegate {
    func adMetadataDidChange(_ ad: AdMetadataProvider) {
        let isNimbusWin: Bool
        if let rewardedInterstitialAd {
            isNimbusWin = dynamicPriceRenderer.handleRewardedInterstitialEventForNimbus(
                adMetadata: ad.adMetadata,
                ad: rewardedInterstitialAd
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

extension GAMRewardedInterstitialViewController: NimbusRewardedAdPresenterDelegate {
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

extension GAMRewardedInterstitialViewController: NimbusRequestManagerDelegate {
    func didCompleteNimbusRequest(request: NimbusRequestKit.NimbusRequest, ad: NimbusCoreKit.NimbusAd) {
        print("didCompleteNimbusRequest")
        
        ad.applyDynamicPrice(into: gamRequest, mapping: mapping)
        
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
            rewardedInterstitialAd.paidEventHandler = { [weak self] adValue in
                guard let self else { return }
                
                self.dynamicPriceRenderer.notifyRewardedInterstitialPrice(
                    adValue: adValue,
                    fullScreenPresentingAd: rewardedInterstitialAd
                )
            }
            
            dynamicPriceRenderer.willRender(ad: ad, fullScreenPresentingAd: rewardedInterstitialAd)
            
            rewardedAdPresenter = NimbusRewardedAdPresenter(
                request: request,
                ad: ad,
                rewardedInterstitialAd: rewardedInterstitialAd
            )
            rewardedAdPresenter?.delegate = self
        }
    }
    
    func didFailNimbusRequest(request: NimbusRequestKit.NimbusRequest, error: NimbusCoreKit.NimbusError) {
        print("didFailNimbusRequest: \(error.localizedDescription)")
    }
    
}
