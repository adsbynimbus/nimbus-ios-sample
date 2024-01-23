//
//  GAMBannerViewController.swift
//  NimbusInternalSampleApp
//  Created on 1/19/24
//  Copyright © 2024 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
#if canImport(NimbusGAMKit)                    // Swift Package Manager
import NimbusGAMKit
#endif
import GoogleMobileAds

let googleDynamicPricePlacementId = Bundle.main.infoDictionary?["Google Nimbus Rendering Placement ID"] as? String ?? ""
let googleDynamicPriceRewardedPlacementId = Bundle.main.infoDictionary?["Google Nimbus Rendering Rewarded Placement ID"] as? String ?? ""

class GAMBannerViewController: SampleAdViewController {
    private let requestManager = NimbusRequestManager()
    private lazy var dynamicPriceRenderer: NimbusDynamicPriceRenderer = {
        return NimbusDynamicPriceRenderer(requestManager: requestManager)
    }()
    
    private let gamRequest = GAMRequest()
    private let bannerView = GAMBannerView(adSize: GADAdSizeBanner)
    private var gamDynamicPrice: NimbusGAMDynamicPrice?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBannerView()
        
        gamDynamicPrice = NimbusGAMDynamicPrice(request: gamRequest)
        gamDynamicPrice?.requestDelegate = self
        
        requestManager.delegate = gamDynamicPrice
        requestManager.performRequest(request: NimbusRequest.forBannerAd(position: "test_dp_rendering"))
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

extension GAMBannerViewController: GADAppEventDelegate {
    func adView(_ banner: GADBannerView, didReceiveAppEvent name: String, withInfo info: String?) {
        print("adView:didReceiveAppEvent")
        dynamicPriceRenderer.handleBannerEventForNimbus(bannerView: banner, name: name, info: info)
    }
}

// MARK: - GADBannerViewDelegate

extension GAMBannerViewController: GADBannerViewDelegate {
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

extension GAMBannerViewController: NimbusRequestManagerDelegate {
    func didCompleteNimbusRequest(request: NimbusRequestKit.NimbusRequest, ad: NimbusCoreKit.NimbusAd) {
        print("didCompleteNimbusRequest")
        
        dynamicPriceRenderer.willRender(ad: ad, bannerView: bannerView)
        bannerView.load(gamRequest)
    }
    
    func didFailNimbusRequest(request: NimbusRequestKit.NimbusRequest, error: NimbusCoreKit.NimbusError) {
        print("didFailNimbusRequest: \(error.localizedDescription)")
    }
    
}
