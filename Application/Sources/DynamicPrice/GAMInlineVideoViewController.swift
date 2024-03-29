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
    private lazy var dynamicPriceRenderer: NimbusDynamicPriceRenderer = {
        return NimbusDynamicPriceRenderer(requestManager: requestManager)
    }()
    
    private let gamRequest = GAMRequest()
    private let bannerView = GAMBannerView(adSize: GADAdSizeMediumRectangle)
    
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
        bannerView.paidEventHandler = { [weak self] adValue in
            guard let bannerView = self?.bannerView else { return }
            self?.dynamicPriceRenderer.notifyBannerPrice(adValue: adValue, bannerView: bannerView)
        }
        
        view.addSubview(bannerView)
        
        NSLayoutConstraint.activate([
            bannerView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            bannerView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
}

// MARK: - GADAppEventDelegate

extension GAMInlineVideoViewController: GADAppEventDelegate {
    func adView(_ banner: GADBannerView, didReceiveAppEvent name: String, withInfo info: String?) {
        print("adView:didReceiveAppEvent")
        dynamicPriceRenderer.handleBannerEventForNimbus(bannerView: banner, name: name, info: info)
    }
}

// MARK: - GADBannerViewDelegate

extension GAMInlineVideoViewController: GADBannerViewDelegate {
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

extension GAMInlineVideoViewController: NimbusRequestManagerDelegate {
    func didCompleteNimbusRequest(request: NimbusRequestKit.NimbusRequest, ad: NimbusCoreKit.NimbusAd) {
        print("didCompleteNimbusRequest")
        
        dynamicPriceRenderer.willRender(ad: ad, bannerView: bannerView)
        ad.applyDynamicPrice(into: gamRequest, mapping: mapping)
        bannerView.load(gamRequest)
    }
    
    func didFailNimbusRequest(request: NimbusRequestKit.NimbusRequest, error: NimbusCoreKit.NimbusError) {
        print("didFailNimbusRequest: \(error.localizedDescription)")
    }
}
