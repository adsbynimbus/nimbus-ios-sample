//
//  GAMAdLoaderBannerViewController.swift
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

class GAMAdLoaderBannerViewController: GAMBaseViewController {
    private let requestManager = NimbusRequestManager()
    private var adLoader: GADAdLoader?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestManager.delegate = self
        requestManager.performRequest(request: NimbusRequest.forBannerAd(position: headerSubTitle))
    }
}

// MARK: - GADAdLoaderDelegate

extension GAMAdLoaderBannerViewController: GADAdLoaderDelegate, GAMBannerAdLoaderDelegate {
    func validBannerSizes(for adLoader: GADAdLoader) -> [NSValue] {
        [NSValueFromGADAdSize(GADAdSizeBanner)]
    }
    
    func adLoaderDidFinishLoading(_ adLoader: GADAdLoader) {
        print("adLoader finished loading")
    }
    
    func adLoader(_ adLoader: GADAdLoader, didReceive bannerView: GAMBannerView) {
        print("adLoader got bannerView")
        
        bannerView.rootViewController = self
        bannerView.adUnitID = googleDynamicPricePlacementId
        bannerView.appEventDelegate = self
        bannerView.applyDynamicPrice(requestManager: requestManager, delegate: self, ad: adLoader.nimbusAd)
        bannerView.paidEventHandler = { [weak bannerView] adValue in
            bannerView?.updatePrice(adValue)
        }
        
        view.addSubview(bannerView)
        
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bannerView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            bannerView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        print("adLoader failedWithError \(error)")
    }
}

// MARK: - GADAppEventDelegate

extension GAMAdLoaderBannerViewController: GADAppEventDelegate {
    func adView(_ banner: GADBannerView, didReceiveAppEvent name: String, withInfo info: String?) {
        print("adView:didReceiveAppEvent")
        (banner as? GAMBannerView)?.handleEventForNimbus(name: name, info: info)
    }
}

// MARK: - GADBannerViewDelegate

extension GAMAdLoaderBannerViewController: GADBannerViewDelegate {
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("bannerViewDidReceiveAd")
    }
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
        print("bannerViewDidRecordImpression")
    }
    
    func bannerViewDidRecordClick(_ bannerView: GADBannerView) {
        print("bannerViewDidRecordClick")
    }
    
    func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("bannerViewWillPresentScreen")
    }
    
    func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("bannerViewWillDismissScreen")
    }
    
    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("bannerViewDidDismissScreen")
    }
}

// MARK: - NimbusRequestManagerDelegate

extension GAMAdLoaderBannerViewController: NimbusRequestManagerDelegate {
    func didCompleteNimbusRequest(request: NimbusRequestKit.NimbusRequest, ad: NimbusCoreKit.NimbusAd) {
        print("didCompleteNimbusRequest")
        
        adLoader = GADAdLoader(
            adUnitID: googleDynamicPricePlacementId,
            rootViewController: self,
            adTypes: [.gamBanner],
            options: nil
        )
        adLoader?.delegate = self
        adLoader?.loadDynamicPrice(ad: ad, gamRequest: GAMRequest())
    }
    
    func didFailNimbusRequest(request: NimbusRequestKit.NimbusRequest, error: NimbusCoreKit.NimbusError) {
        print("didFailNimbusRequest: \(error.localizedDescription)")
    }
}
