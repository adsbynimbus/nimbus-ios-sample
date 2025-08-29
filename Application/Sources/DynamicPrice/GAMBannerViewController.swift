//
//  GAMBannerViewController.swift
//  NimbusInternalSampleApp
//  Created on 1/19/24
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

class GAMBannerViewController: GAMBaseViewController {
    private static let refreshInterval: TimeInterval = 30
    private let bannerView = AdManagerBannerView(adSize: AdSizeBanner)
    private let requestManager = NimbusRequestManager()
    
    private var refreshTimer: Timer?
    
    /// Set this to false if you don't want a refreshing banner
    private var isRefreshingBanner = true
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            setupBannerView()
            await load()
            
            if isRefreshingBanner {
                setupNotifications()
                setupRefreshTimer()
            }
        }
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
    
    func setupBannerView() {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        bannerView.adUnitID = googleDynamicPricePlacementId
        bannerView.rootViewController = self
        bannerView.appEventDelegate = self
        bannerView.delegate = self
        
        view.addSubview(bannerView)
        
        NSLayoutConstraint.activate([
            bannerView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            bannerView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    func fetchNimbusBid() async -> Ad? {
        do {
            return try await Nimbus.bannerAd(position: headerSubTitle).fetch()
        } catch {
            print("Failed fetching Nimbus bid: \(error)")
            return nil
        }
    }
    
    func load() async {
        bannerView.loadDynamicPrice(gamRequest: AdManagerRequest(), ad: await fetchNimbusBid(), mapping: mapping)
    }
    
    // MARK: - Refreshing Banner Logic
    
    func setupRefreshTimer() {
        refreshTimer?.invalidate() // just to make sure there's no outstanding timer
        refreshTimer = Timer.scheduledTimer(withTimeInterval: Self.refreshInterval, repeats: true) { [weak self] _ in
            Task { await self?.load() }
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

// MARK: - GADAppEventDelegate

extension GAMBannerViewController: @preconcurrency AppEventDelegate {
    func adView(_ banner: BannerView, didReceiveAppEvent name: String, with info: String?) {
        print("adView:didReceiveAppEvent")
        banner.handleEventForNimbus(name: name, info: info)
    }
}

// MARK: - GADBannerViewDelegate

extension GAMBannerViewController: BannerViewDelegate {
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
