//
//  GAMInterstitialViewController.swift
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

class GAMInterstitialViewController: GAMBaseViewController {
    private let requestManager = NimbusRequestManager()
    private var interstitialAd: GAMInterstitialAd?
    private let gamRequest = GAMRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestManager.delegate = self
        requestManager.performRequest(request: NimbusRequest.forInterstitialAd(position: headerSubTitle))
    }
    
    func loadInterstitial(nimbusAd: NimbusAd? = nil) {
        nimbusAd?.applyDynamicPrice(into: gamRequest, mapping: mapping)
        
        GAMInterstitialAd.load(
            withAdManagerAdUnitID: googleDynamicPricePlacementId,
            request: gamRequest
        ) { [weak self] interstitialAd, error in
            if let error {
                print("Failed to load dynamic price interstitial ad with error: \(error.localizedDescription)")
                return
            }
            
            guard let self, let interstitialAd else { return }
            
            self.interstitialAd = interstitialAd
            
            if let ad = nimbusAd {
                interstitialAd.applyDynamicPrice(
                    ad: ad,
                    requestManager: requestManager,
                    delegate: self
                )
            } else {
                interstitialAd.fullScreenContentDelegate = self
            }
            
            interstitialAd.appEventDelegate = self
            interstitialAd.paidEventHandler = { [weak interstitialAd] adValue in
                interstitialAd?.updatePrice(adValue)
            }
            
            DispatchQueue.main.async {
                interstitialAd.presentDynamicPrice(fromRootViewController: self, isDismissAnimated: false)
            }
        }
    }
}

// MARK: - GADAppEventDelegate

extension GAMInterstitialViewController: GADAppEventDelegate {
    func interstitialAd(_ interstitialAd: GADInterstitialAd, didReceiveAppEvent name: String, withInfo info: String?) {
        interstitialAd.handleEventForNimbus(name: name, info: info)
    }
}

// MARK: - GADFullScreenContentDelegate

extension GAMInterstitialViewController: GADFullScreenContentDelegate {
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("ad:didFailToPresentFullScreenContentWithError: \(error.localizedDescription)")
    }
    
    func adDidRecordImpression(_ ad: GADFullScreenPresentingAd) {
        print("adDidRecordImpression")
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

// MARK: - NimbusRequestManagerDelegate

extension GAMInterstitialViewController: NimbusRequestManagerDelegate {
    func didCompleteNimbusRequest(request: NimbusRequestKit.NimbusRequest, ad: NimbusCoreKit.NimbusAd) {
        print("didCompleteNimbusRequest")
        
        loadInterstitial(nimbusAd: ad)
    }
    
    func didFailNimbusRequest(request: NimbusRequestKit.NimbusRequest, error: NimbusCoreKit.NimbusError) {
        print("didFailNimbusRequest: \(error.localizedDescription)")
        
        loadInterstitial()
    }
    
}
