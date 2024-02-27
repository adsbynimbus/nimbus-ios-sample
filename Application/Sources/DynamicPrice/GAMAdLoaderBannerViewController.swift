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
    private static let refreshInterval: TimeInterval = 30
    
    private let requestManager = NimbusRequestManager()
    private var adLoader: GADAdLoader?
    private weak var bannerView: GAMBannerView?
    
    private var refreshTimer: Timer?
    
    /// Set this to false if you don't want a refreshing banner
    private var isRefreshingBanner = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isRefreshingBanner {
            setupNotifications()
            setupRefreshTimer()
        }
        
        requestManager.delegate = self
        
        load()
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
    
    // MARK: - Refreshing Banner Logic
    
    func setupRefreshTimer() {
        refreshTimer?.invalidate() // just to make sure there's no outstanding timer
        refreshTimer = Timer.scheduledTimer(withTimeInterval: Self.refreshInterval, repeats: true) { [weak self] _ in
            self?.load()
        }
        print("\(Self.self) created refresh timer")
    }
    
    @objc private func appDidBecomeActive() {
        setupRefreshTimer()
    }
    
    @objc private func appWillResignActive() {
        refreshTimer?.invalidate()
        print("\(Self.self) removed refresh timer")
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
        bannerView.applyDynamicPrice(
            requestManager: requestManager,
            delegate: self,
            ad: adLoader.nimbusAd
        )
        bannerView.paidEventHandler = { [weak bannerView] adValue in
            bannerView?.updatePrice(adValue)
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

extension GAMAdLoaderBannerViewController: GADAppEventDelegate {
    func adView(_ banner: GADBannerView, didReceiveAppEvent name: String, withInfo info: String?) {
        print("adView:didReceiveAppEvent")
        bannerView?.handleEventForNimbus(name: name, info: info)
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
        
        // Remove old bannerView if exists
        bannerView?.removeFromSuperview()
        
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
