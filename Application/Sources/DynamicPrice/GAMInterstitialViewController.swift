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
    private lazy var dynamicPriceRenderer: NimbusDynamicPriceRenderer = {
        return NimbusDynamicPriceRenderer(requestManager: requestManager)
    }()
    
    private let gamRequest = GAMRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestManager.delegate = self
        requestManager.performRequest(request: NimbusRequest.forInterstitialAd(position: headerSubTitle))
    }
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?) {
        super.present(viewControllerToPresent, animated: flag, completion: { [weak self] in
            self?.dynamicPriceRenderer.willPresent()
            completion?()
        })
    }
}

// MARK: - GADAppEventDelegate

extension GAMInterstitialViewController: GADAppEventDelegate {
    func interstitialAd(_ interstitialAd: GADInterstitialAd, didReceiveAppEvent name: String, withInfo info: String?) {
        dynamicPriceRenderer.handleInterstitialEventForNimbus(name: name, info: info)
    }
}

// MARK: - GADFullScreenContentDelegate

extension GAMInterstitialViewController: GADFullScreenContentDelegate {
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

// MARK: - NimbusRequestManagerDelegate

extension GAMInterstitialViewController: NimbusRequestManagerDelegate {
    func didCompleteNimbusRequest(request: NimbusRequestKit.NimbusRequest, ad: NimbusCoreKit.NimbusAd) {
        print("didCompleteNimbusRequest")
        
        ad.applyDynamicPrice(into: gamRequest, mapping: mapping)
        
        GAMInterstitialAd.load(
            withAdManagerAdUnitID: googleDynamicPricePlacementId,
            request: gamRequest
        ) { [weak self] interstitialAd, error in
            if let error {
                print("Failed to load dynamic price interstitial ad with error: \(error.localizedDescription)")
                return
            }
            
            guard let self, let interstitialAd else { return }
            
            interstitialAd.fullScreenContentDelegate = self
            interstitialAd.appEventDelegate = self
            interstitialAd.paidEventHandler = { [weak self] adValue in
                guard let self else { return }
                
                self.dynamicPriceRenderer.notifyInterstitialPrice(
                    adValue: adValue,
                    fullScreenPresentingAd: interstitialAd
                )
            }
            
            DispatchQueue.main.async {
                self.dynamicPriceRenderer.willRender(ad: ad, fullScreenPresentingAd: interstitialAd)
                interstitialAd.present(fromRootViewController: self)
            }
        }
    }
    
    func didFailNimbusRequest(request: NimbusRequestKit.NimbusRequest, error: NimbusCoreKit.NimbusError) {
        print("didFailNimbusRequest: \(error.localizedDescription)")
    }
    
}
