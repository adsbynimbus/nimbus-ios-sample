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
    private var adLoader: AdLoader?
    private weak var bannerView: AdManagerBannerView?
    
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
        
        fetchNimbusBid()
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
    
    func fetchNimbusBid() {
        requestManager.performRequest(request: NimbusRequest.forBannerAd(position: headerSubTitle))
    }
    
    func load(ad: NimbusAd? = nil) {
        adLoader = AdLoader(
            adUnitID: googleDynamicPricePlacementId,
            rootViewController: self,
            adTypes: [.adManagerBanner],
            options: nil
        )
        adLoader?.delegate = self
        adLoader?.loadDynamicPrice(gamRequest: AdManagerRequest(), ad: ad, mapping: mapping)
    }
    
    // MARK: - Refreshing Banner Logic
    
    func setupRefreshTimer() {
        refreshTimer?.invalidate() // just to make sure there's no outstanding timer
        refreshTimer = Timer.scheduledTimer(withTimeInterval: Self.refreshInterval, repeats: true) { [weak self] _ in
            self?.fetchNimbusBid()
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

extension GAMAdLoaderBannerViewController: AdLoaderDelegate, AdManagerBannerAdLoaderDelegate {
    func validBannerSizes(for adLoader: AdLoader) -> [NSValue] {
        [nsValue(for: AdSizeBanner)]
    }
    
    func adLoaderDidFinishLoading(_ adLoader: AdLoader) {
        print("adLoader finished loading")
    }
    
    func adLoader(_ adLoader: AdLoader, didReceive bannerView: AdManagerBannerView) {
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
    
    func adLoader(_ adLoader: AdLoader, didFailToReceiveAdWithError error: Error) {
        print("adLoader failedWithError \(error)")
    }
}

// MARK: - GADAppEventDelegate

extension GAMAdLoaderBannerViewController: AppEventDelegate {
    func adView(_ banner: BannerView, didReceiveAppEvent name: String, with info: String?) {
        print("adView:didReceiveAppEvent")
        bannerView?.handleEventForNimbus(name: name, info: info)
    }
}

// MARK: - GADBannerViewDelegate

extension GAMAdLoaderBannerViewController: BannerViewDelegate {
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

extension GAMAdLoaderBannerViewController: NimbusRequestManagerDelegate {
    func didCompleteNimbusRequest(request: NimbusRequest, ad: NimbusAd) {
        print("didCompleteNimbusRequest")
        
        // Remove old bannerView if exists
        bannerView?.removeFromSuperview()
        
        load(ad: ad)
    }
    
    func didFailNimbusRequest(request: NimbusRequest, error: NimbusError) {
        print("didFailNimbusRequest: \(error.localizedDescription)")
        load()
    }
}
