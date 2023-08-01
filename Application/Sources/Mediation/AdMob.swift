//
//  AdMob.swift
//  NimbusInternalSampleApp
//
//  Created by Inder Dhir on 6/27/23.
//  Copyright © 2023 Timehop. All rights reserved.
//

import GoogleMobileAds
import NimbusKit
#if canImport(NimbusSDK) // CocoaPods
import NimbusSDK
#else                    // Swift Package Manager
import NimbusGoogleKit
#endif
import UIKit

fileprivate let bannerPlacementId = Bundle.main.infoDictionary?["AdMob Banner ID"] as? String ?? ""
fileprivate let interstitialPlacementId = Bundle.main.infoDictionary?["AdMob Interstitial ID"] as? String ?? ""
fileprivate let rewardedPlacementId = Bundle.main.infoDictionary?["AdMob Rewarded ID"] as? String ?? ""
fileprivate let rewardedInterstitialPlacementId = Bundle.main.infoDictionary?["AdMob Rewarded Interstitial ID"] as? String ?? ""

final class AdMobViewController: DemoViewController {
    
    private let adType: DynamicPriceAdMob
    private let requestManager = NimbusRequestManager()
    private var bannerView: GADBannerView?
    private var interstitial: GADInterstitialAd?
    private var rewardedAd: GADRewardedAd?
    private var rewardedInterstitialAd: GADRewardedInterstitialAd?
    private var nimbusAd: NimbusAd?
    private var nimbusGoogleExtras: NimbusGoogleAdNetworkExtras?
    
    init(adType: DynamicPriceAdMob, headerSubTitle: String) {
        self.adType = adType
        super.init(headerTitle: adType.description, headerSubTitle: headerSubTitle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAdRendering()
    }
    
    private func setupAdRendering() {
        switch adType {
            
        case .dynamicPriceBanner:
            setupBannerAd()
            
        case .dynamicPriceInterstitial:
            setupInterstitialAd()
            
        case .dynamicPriceRewarded:
            setupRewardedAd()
            
        case .dynamicPriceRewardedInterstitial:
            setupRewardedInterstitialAd()
        }
    }
    
    private func setupBannerAd() {
        if bannerPlacementId.isEmpty {
            showCustomAlert("admob_banner_placement_id")
            return
        }
        
        bannerView = GADBannerView(adSize: GADAdSizeBanner)
        guard let bannerView else { return }
        bannerView.rootViewController = self
        bannerView.adUnitID = bannerPlacementId
        bannerView.delegate = self
        bannerView.isAccessibilityElement = true
        bannerView.accessibilityIdentifier = "google_ad_view"
        bannerView.paidEventHandler = { [weak self] adValue in
            if let nimbusGoogleExtras = self?.nimbusGoogleExtras {
                NimbusCustomAdapter.notifyPrice(extras: nimbusGoogleExtras, adValue: adValue)
            }
        }
        
        let gadRequest = GADRequest()
        nimbusGoogleExtras = try? NimbusGoogleAdNetworkExtras(position: "nimbus_admob_banner")
        if let nimbusGoogleExtras {
            gadRequest.register(nimbusGoogleExtras)
            bannerView.load(gadRequest)
        } else {
            print("Error creating extras for Google banner ad")
        }
    }
    
    private func setupInterstitialAd() {
        if interstitialPlacementId.isEmpty {
            showCustomAlert("admob_interstitial_placement_id")
            return
        }
        
        let gadRequest = GADRequest()
        do {
            nimbusGoogleExtras = try NimbusGoogleAdNetworkExtras(position: "nimbus_admob_interstitial")
            if let nimbusGoogleExtras {
                gadRequest.register(nimbusGoogleExtras)
            }

            GADInterstitialAd.load(
                withAdUnitID: interstitialPlacementId,
                request: gadRequest
            ) { [weak self] ad, error in
                if let error {
                    print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                    return
                }
                
                guard let self else { return }
                self.interstitial = ad
                self.interstitial?.fullScreenContentDelegate = self
                self.interstitial?.paidEventHandler = { [weak self] adValue in
                    if let nimbusGoogleExtras = self?.nimbusGoogleExtras {
                        NimbusCustomAdapter.notifyPrice(extras: nimbusGoogleExtras, adValue: adValue)
                    }
                }
                
                ad?.present(fromRootViewController: self)
            }
        } catch {
            print("Error creating extras for Google interstitial ad")
        }
    }
    
    private func setupRewardedAd() {
        if rewardedPlacementId.isEmpty {
            showCustomAlert("admob_rewarded_placement_id")
            return
        }
        
        let gadRequest = GADRequest()
        do {
            nimbusGoogleExtras = try NimbusGoogleAdNetworkExtras(position: "nimbus_admob_rewarded")
            if let nimbusGoogleExtras {
                gadRequest.register(nimbusGoogleExtras)
            }
            
            GADRewardedAd.load(
                withAdUnitID: rewardedPlacementId,
                request: gadRequest,
                completionHandler: { [weak self] ad, error in
                    if let error {
                        // TODO: Nimbus loss notification?
                        print("Failed to load rewarded ad with error: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let self else { return }
                    print("Rewarded ad loaded.")
                    
                    self.rewardedAd = ad
                    rewardedAd?.fullScreenContentDelegate = self
                    rewardedAd?.paidEventHandler = { [weak self] adValue in
                        if let nimbusGoogleExtras = self?.nimbusGoogleExtras {
                            NimbusCustomAdapter.notifyPrice(extras: nimbusGoogleExtras, adValue: adValue)
                        }
                    }
                    
                    if let ad = rewardedAd {
                        ad.present(fromRootViewController: self) {
                            let reward = ad.adReward
                            print("Reward received with currency \(reward.amount), amount \(reward.amount.doubleValue)")
                        }
                    }
                }
            )
        } catch {
            print("Error creating extras for Google rewarded ad")
        }
    }
    
    private func setupRewardedInterstitialAd() {
        if rewardedInterstitialPlacementId.isEmpty {
            showCustomAlert("admob_rewarded_interstitial_placement_id")
            return
        }
        
        let gadRequest = GADRequest()
        do {
            nimbusGoogleExtras = try NimbusGoogleAdNetworkExtras(position: "nimbus_admob_rewarded_interstitial")
            if let nimbusGoogleExtras {
                gadRequest.register(nimbusGoogleExtras)
            }
            
            GADRewardedInterstitialAd.load(
                withAdUnitID: rewardedInterstitialPlacementId,
                request: gadRequest
            ) { ad, error in
                if let error {
                    return print("Failed to load rewarded interstitial ad with error: \(error.localizedDescription)")
                }
                
                self.rewardedInterstitialAd = ad
                self.rewardedInterstitialAd?.fullScreenContentDelegate = self
                self.rewardedInterstitialAd?.paidEventHandler = { [weak self] adValue in
                    if let nimbusGoogleExtras = self?.nimbusGoogleExtras {
                        NimbusCustomAdapter.notifyPrice(extras: nimbusGoogleExtras, adValue: adValue)
                    }
                }
                
                if let ad {
                    ad.present(fromRootViewController: self) {
                        let _ = ad.adReward
                    }
                }
            }
        } catch {
            print("Error creating extras for Google rewarded interstitial ad")
        }
    }
}

// MARK: - GADBannerViewDelegate

extension AdMobViewController: GADBannerViewDelegate {
    
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("bannerViewDidReceiveAd")
        
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        
        NSLayoutConstraint.activate([
            bannerView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            bannerView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor),
            bannerView.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor),
            bannerView.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor),
            bannerView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
        ])
        
        /* Set identifiers for UI testing */
//        bannerView.nimbusAdView?.setUiTestIdentifiers(for: "test_demand static 320x50", id: "nimbus_ad_view")
    }
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
        
        if let nimbusGoogleExtras {
            NimbusCustomAdapter.notifyError(extras: nimbusGoogleExtras, error: error)
        }
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
    
    func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
        print("bannerViewDidRecordImpression")
        
        if let nimbusGoogleExtras {
            NimbusCustomAdapter.notifyImpression(
                extras: nimbusGoogleExtras,
                adNetworkResponseInfo: bannerView.responseInfo?.loadedAdNetworkResponseInfo
            )
        }
    }
}

// MARK: - GADFullScreenContentDelegate

extension AdMobViewController: GADFullScreenContentDelegate {
    
    func adDidRecordImpression(_ ad: GADFullScreenPresentingAd) {
        print("adDidRecordImpression")
        
        let adNetworkResponseInfo: GADAdNetworkResponseInfo?
        if let interstitialAd = ad as? GADInterstitialAd {
            adNetworkResponseInfo = interstitialAd.responseInfo.loadedAdNetworkResponseInfo
        } else if let rewardedAd = ad as? GADRewardedAd {
            adNetworkResponseInfo = rewardedAd.responseInfo.loadedAdNetworkResponseInfo
        } else {
            adNetworkResponseInfo = nil
        }
        
        if let nimbusGoogleExtras {
            NimbusCustomAdapter.notifyImpression(
                extras: nimbusGoogleExtras,
                adNetworkResponseInfo: adNetworkResponseInfo
            )
        }
    }
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("ad:didFailToPresentFullScreenContentWithError: \(error.localizedDescription)")
        
        if let nimbusGoogleExtras {
            NimbusCustomAdapter.notifyError(extras: nimbusGoogleExtras, error: error)
        }
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("adDidDismissFullScreenContent")
    }
}
