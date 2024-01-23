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
    private lazy var dynamicPriceRenderer: NimbusDynamicPriceRenderer = {
        return NimbusDynamicPriceRenderer(requestManager: requestManager)
    }()
    
    private let gamRequest = GAMRequest()
    private var adLoader: GADAdLoader?
    private var ad: NimbusAd?
    
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
        
        if let ad {
            dynamicPriceRenderer.willRender(ad: ad, bannerView: bannerView)
        }
        
        bannerView.rootViewController = self
        bannerView.adUnitID = googleDynamicPricePlacementId
        bannerView.delegate = self
        bannerView.appEventDelegate = self
        bannerView.paidEventHandler = { [weak self] adValue in
            self?.dynamicPriceRenderer.notifyBannerPrice(adValue: adValue, bannerView: bannerView)
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
        dynamicPriceRenderer.handleBannerEventForNimbus(bannerView: banner, name: name, info: info)
    }
}

// MARK: - GADBannerViewDelegate

extension GAMAdLoaderBannerViewController: GADBannerViewDelegate {
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("bannerViewDidReceiveAd")
    }
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
        dynamicPriceRenderer.notifyBannerLoss(bannerView: bannerView, error: error)
    }
    
    func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
        print("bannerViewDidRecordImpression")
        dynamicPriceRenderer.notifyBannerImpression(bannerView: bannerView)
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
        
        ad.applyDynamicPrice(into: gamRequest, mapping: mapping)
        self.ad = ad
        
        adLoader = GADAdLoader(
            adUnitID: googleDynamicPricePlacementId,
            rootViewController: self,
            adTypes: [.gamBanner],
            options: nil
        )
        adLoader?.delegate = self
        adLoader?.load(gamRequest)
    }
    
    func didFailNimbusRequest(request: NimbusRequestKit.NimbusRequest, error: NimbusCoreKit.NimbusError) {
        print("didFailNimbusRequest: \(error.localizedDescription)")
    }
}
