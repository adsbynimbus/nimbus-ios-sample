//
//  GAMInlineVideoViewController.swift
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

class GAMInlineVideoViewController: GAMBaseViewController {
    private let requestManager = NimbusRequestManager()
    private let gamRequest = AdManagerRequest()
    private let bannerView = AdManagerBannerView(adSize: AdSizeMediumRectangle)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBannerView()
        
        requestManager.delegate = self
        requestManager.performRequest(request: NimbusRequest.forVideoAd(position: headerSubTitle))
    }
    
    func setupBannerView() {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        bannerView.adUnitID = googleDynamicPricePlacementId
        bannerView.delegate = self
        bannerView.rootViewController = self
        bannerView.appEventDelegate = self
        
        view.addSubview(bannerView)
        
        NSLayoutConstraint.activate([
            bannerView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            bannerView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
}

// MARK: - GADAppEventDelegate

extension GAMInlineVideoViewController: AppEventDelegate {
    func adView(_ banner: BannerView, didReceiveAppEvent name: String, with info: String?) {
        print("adView:didReceiveAppEvent")
        bannerView.handleEventForNimbus(name: name, info: info)
    }
}

// MARK: - GADBannerViewDelegate

extension GAMInlineVideoViewController: BannerViewDelegate {
    func bannerViewDidReceiveAd(_ bannerView: BannerView) {
        print("bannerViewDidReceiveAd")
    }
    
    func bannerView(_ bannerView: BannerView, didFailToReceiveAdWithError error: Error) {
        print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    func bannerViewDidRecordImpression(_ bannerView: BannerView) {
        print("bannerViewDidRecordImpression")
    }
    
    func bannerViewDidRecordClick(_ bannerView: BannerView) {
        print("bannerViewDidRecordClick")
    }
    
    func bannerViewWillPresentScreen(_ bannerView: BannerView) {
        print("bannerViewWillPresentScreen")
    }
    
    func bannerViewWillDismissScreen(_ bannerView: BannerView) {
        print("bannerViewWillDismissScreen")
    }
    
    func bannerViewDidDismissScreen(_ bannerView: BannerView) {
        print("bannerViewDidDismissScreen")
    }
}

// MARK: - NimbusRequestManagerDelegate

extension GAMInlineVideoViewController: NimbusRequestManagerDelegate {
    func didCompleteNimbusRequest(request: NimbusRequestKit.NimbusRequest, ad: NimbusCoreKit.NimbusAd) {
        print("didCompleteNimbusRequest")
        
        bannerView.loadDynamicPrice(gamRequest: AdManagerRequest(), ad: ad, mapping: mapping)
    }
    
    func didFailNimbusRequest(request: NimbusRequestKit.NimbusRequest, error: NimbusCoreKit.NimbusError) {
        print("didFailNimbusRequest: \(error.localizedDescription)")
        bannerView.loadDynamicPrice(gamRequest: AdManagerRequest(), mapping: mapping)
    }
}
