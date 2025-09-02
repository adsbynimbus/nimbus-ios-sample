//
//  GAMAdLoaderBannerViewController.swift
//  NimbusInternalSampleApp
//  Created on 1/23/24
//  Copyright © 2024 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import NimbusCoreKit
import NimbusKit
#if canImport(NimbusGAMKit)                    // Swift Package Manager
import NimbusGAMKit
#elseif canImport(NimbusSDK)                   // CocoaPods
import NimbusSDK
#endif
import GoogleMobileAds

class GAMAdLoaderBannerViewController: GAMBaseViewController {
    private static let refreshInterval: TimeInterval = 30
    
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
        
        fetchAndLoad()
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
    
    func fetchNimbusBid() async -> Ad? {
        do {
            return try await Nimbus.bannerAd(position: headerSubTitle).fetch()
        } catch {
            print("Failed fetching Nimbus bid: \(error)")
            return nil
        }
    }
    
    func load(ad: Ad? = nil) {
        adLoader = AdLoader(
            adUnitID: googleDynamicPricePlacementId,
            rootViewController: self,
            adTypes: [.adManagerBanner],
            options: nil
        )
        adLoader?.delegate = self
        adLoader?.loadDynamicPrice(gamRequest: AdManagerRequest(), ad: ad, mapping: mapping)
    }
    
    func fetchAndLoad() {
        Task { load(ad: await fetchNimbusBid()) }
    }
    
    // MARK: - Refreshing Banner Logic
    
    func setupRefreshTimer() {
        refreshTimer?.invalidate() // just to make sure there's no outstanding timer
        refreshTimer = Timer.scheduledTimer(withTimeInterval: Self.refreshInterval, repeats: true) { [weak self] _ in
            self?.fetchAndLoad()
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

extension GAMAdLoaderBannerViewController: @preconcurrency AdLoaderDelegate, @preconcurrency AdManagerBannerAdLoaderDelegate {
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
        bannerView.delegate = self
        bannerView.applyDynamicPrice(ad: adLoader.nimbusAd)
        
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

extension GAMAdLoaderBannerViewController: @preconcurrency AppEventDelegate {
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
