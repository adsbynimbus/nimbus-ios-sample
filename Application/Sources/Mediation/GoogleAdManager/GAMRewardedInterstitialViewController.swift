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
    
    private let gamRequest = GAMRequest()
    private var rewardedInterstitialAd: GADRewardedInterstitialAd?
    private var gamDynamicPrice: NimbusGAMDynamicPrice?
    private var rewardedAdPresenter: NimbusRewardedAdPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gamDynamicPrice = NimbusGAMDynamicPrice(request: gamRequest)
        gamDynamicPrice?.requestDelegate = self
        
        requestManager.delegate = gamDynamicPrice
        requestManager.performRequest(request: NimbusRequest.forRewardedVideo(position: "test_dp_rendering"))
    }
}

// MARK: - GADFullScreenContentDelegate

extension GAMRewardedInterstitialViewController: GADFullScreenContentDelegate {
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("ad:didFailToPresentFullScreenContentWithError: \(error.localizedDescription)")
        
        if let interstitialAd = ad as? GADInterstitialAd {
            dynamicPriceRenderer.notifyInterstitialLoss(fullScreenPresentingAd: interstitialAd, error: error)
        }
    }
    
    func adDidRecordImpression(_ ad: GADFullScreenPresentingAd) {
        print("adDidRecordImpression")
        
        if let interstitialAd = ad as? GADInterstitialAd {
            dynamicPriceRenderer.notifyInterstitialImpression(interstitialAd: interstitialAd)
        }
    }
    
    func adDidRecordClick(_ ad: GADFullScreenPresentingAd) {
        print("adDidRecordClick")
    }
    
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("ad:adWillPresentFullScreenContent")
    }
    
    func adWillDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("adWillDismissFullScreenContent")
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("adDidDismissFullScreenContent")
    }
}

// MARK: - GADAdMetadataDelegate

extension GAMRewardedInterstitialViewController: GADAdMetadataDelegate {
    func adMetadataDidChange(_ ad: GADAdMetadataProvider) {
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
   
    func didEarnReward(reward: GADAdReward) {
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
        
        GADRewardedInterstitialAd.load(
            withAdUnitID: googleDynamicPriceRewardedPlacementId,
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
