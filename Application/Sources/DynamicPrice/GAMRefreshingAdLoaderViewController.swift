//
//  GAMRefreshingAdLoaderViewController.swift
//  NimbusInternalSampleApp
//  Created on 2/23/24
//  Copyright © 2024 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
#if canImport(NimbusGAMKit)                    // Swift Package Manager
import NimbusGAMKit
#elseif canImport(NimbusSDK)                   // CocoaPods
import NimbusSDK
#endif
import GoogleMobileAds

class GAMRefreshingAdLoaderBannerViewController: GAMBaseViewController {
    private let requestManager = NimbusRequestManager()
    private lazy var dynamicPriceRenderer: NimbusDynamicPriceRenderer = {
        return NimbusDynamicPriceRenderer(requestManager: requestManager)
    }()
    
    private let gamRequest = GAMRequest()
    private var adLoader: GADAdLoader?
    private var ad: NimbusAd?
    private var timer: Timer?
    private var bannerView: GADBannerView?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNotifications()
        
        requestManager.delegate = self
        
        adLoader = GADAdLoader(
            adUnitID: googleDynamicPricePlacementId,
            rootViewController: self,
            adTypes: [.gamBanner],
            options: nil
        )
        adLoader?.delegate = self
        
        load()
        createTimer()
    }
    
    func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appWillResignActive),
            name: UIApplication.willResignActiveNotification,
            object: nil
        )
    }
    
    func load() {
        requestManager.performRequest(request: NimbusRequest.forBannerAd(position: headerSubTitle))
    }
    
    func createTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { [weak self] _ in
            self?.load()
        }
        print("\(Self.self) created refresh timer")
    }
    
    @objc private func appDidBecomeActive() {
        createTimer()
    }
    
    @objc private func appWillResignActive() {
        timer?.invalidate()
        print("\(Self.self) removed refresh timer")
    }
}

// MARK: - GADAdLoaderDelegate

extension GAMRefreshingAdLoaderBannerViewController: GADAdLoaderDelegate, GAMBannerAdLoaderDelegate {
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
        
        self.bannerView?.removeFromSuperview()
        
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
        
        self.bannerView = bannerView
    }
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        print("adLoader failedWithError \(error)")
    }
}

// MARK: - GADAppEventDelegate

extension GAMRefreshingAdLoaderBannerViewController: GADAppEventDelegate {
    func adView(_ banner: GADBannerView, didReceiveAppEvent name: String, withInfo info: String?) {
        print("adView:didReceiveAppEvent")
        dynamicPriceRenderer.handleBannerEventForNimbus(bannerView: banner, name: name, info: info)
    }
}

// MARK: - GADBannerViewDelegate

extension GAMRefreshingAdLoaderBannerViewController: GADBannerViewDelegate {
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

extension GAMRefreshingAdLoaderBannerViewController: NimbusRequestManagerDelegate {
    func didCompleteNimbusRequest(request: NimbusRequestKit.NimbusRequest, ad: NimbusCoreKit.NimbusAd) {
        print("didCompleteNimbusRequest")
        
        ad.applyDynamicPrice(into: gamRequest, mapping: mapping)
        self.ad = ad
        
        adLoader?.load(gamRequest)
    }
    
    func didFailNimbusRequest(request: NimbusRequestKit.NimbusRequest, error: NimbusCoreKit.NimbusError) {
        print("didFailNimbusRequest: \(error.localizedDescription)")
    }
}

