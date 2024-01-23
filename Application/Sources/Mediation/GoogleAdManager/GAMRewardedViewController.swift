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
    
    private let gamRequest = GAMRequest()
    private var rewardedAd: GADRewardedAd?
    private var rewardedAdPresenter: NimbusRewardedAdPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestManager.delegate = self
        requestManager.performRequest(request: NimbusRequest.forRewardedVideo(position: "test_dp_rendering"))
    }
}

// MARK: - GADFullScreenContentDelegate

extension GAMRewardedViewController: GADFullScreenContentDelegate {
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

extension GAMRewardedViewController: GADAdMetadataDelegate {
    func adMetadataDidChange(_ ad: GADAdMetadataProvider) {
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
   
    func didEarnReward(reward: GADAdReward) {
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
        
        GADRewardedAd.load(
            withAdUnitID: googleDynamicPriceRewardedPlacementId,
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

