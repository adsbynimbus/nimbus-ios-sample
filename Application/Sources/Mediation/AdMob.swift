//
//  GoogleAdMob.swift
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
import NimbusGAMKit
#endif
import UIKit

fileprivate let gamPlacementId = Bundle.main.infoDictionary?["Google Placement ID"] as? String ?? ""

final class AdMobViewController: DemoViewController {
    
    private let adType: AdMobAdType
    private let requestManager = NimbusRequestManager()
    private var bannerView: GAMBannerView?
    private var interstitial: GADInterstitialAd?
    private var gamDynamicPrice: NimbusGAMDynamicPrice?
    private lazy var gamRequest = GAMRequest()
    private var nimbusAd: NimbusAd?
    
    init(adType: AdMobAdType, headerSubTitle: String) {
        self.adType = adType
        super.init(headerTitle: adType.description, headerSubTitle: headerSubTitle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if gamPlacementId.isEmpty { showCustomAlert("google_placement_id") }
        
        setupAdRendering()
    }
    
    private func setupAdRendering() {
//        switch adType {
//            
//        case .banner:
//            bannerView = GAMBannerView(adSize: GADAdSizeBanner)
//            guard let bannerView else { return }
//            bannerView.rootViewController = self
//            bannerView.adUnitID = gamPlacementId
//            bannerView.delegate = self
//            bannerView.isAccessibilityElement = true
//            bannerView.accessibilityIdentifier = "google_ad_view"
//            
//            bannerView.translatesAutoresizingMaskIntoConstraints = false
//            view.addSubview(bannerView)
//            
//            NSLayoutConstraint.activate([
//                bannerView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
//                bannerView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor),
//                bannerView.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor),
//                bannerView.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor),
//                bannerView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
//            ])
//            bannerView.load(gamRequest)
//        case .interstitial:
//            GAMInterstitialAd.load(
//                withAdManagerAdUnitID: gamPlacementId,
//                request: gamRequest
//            ) { (ad, error) in
//                if let error {
//                    print("Failed to load interstitial ad with error: \(error.localizedDescription)")
//                    return
//                }
//                self.interstitial = ad
//                self.interstitial?.fullScreenContentDelegate = self
//                ad?.present(fromRootViewController: self)
//            }
//        }
    }
}

// MARK: - GADBannerViewDelegate

extension AdMobViewController: GADBannerViewDelegate {
    
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("bannerViewDidReceiveAd")
        
        /* Set identifiers for UI testing */
        bannerView.nimbusAdView?.setUiTestIdentifiers(for: "test_demand static 320x50", id: "nimbus_ad_view")
    }
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
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
    }
}

// MARK: - GADFullScreenContentDelegate

extension AdMobViewController: GADFullScreenContentDelegate {
    
    func adDidRecordImpression(_ ad: GADFullScreenPresentingAd) {
        print("adDidRecordImpression")
    }
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("ad:didFailToPresentFullScreenContentWithError: \(error.localizedDescription)")
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("adDidDismissFullScreenContent")
    }
}

// MARK: - NimbusRequestManagerDelegate

extension AdMobViewController: NimbusRequestManagerDelegate {
    
    func didCompleteNimbusRequest(request: NimbusRequest, ad: NimbusAd) {
        print("didCompleteNimbusRequest with \(ad.auctionType) ad type")
        nimbusAd = ad
        if adType == .banner {
            bannerView?.load(gamRequest)
        } else {
            GADInterstitialAd.load(withAdUnitID: gamPlacementId, request: gamRequest) { gadAd, error in
                if let error {
                    print("Failed to load dynamic price interstitial ad with error: \(error.localizedDescription)")
                    return
                }
                self.interstitial = gadAd
                self.interstitial?.fullScreenContentDelegate = self
                
                gadAd?.present(fromRootViewController: self)
            }
        }
    }
    
    
    func didFailNimbusRequest(request: NimbusRequest, error: NimbusError) {
        print("didFailNimbusRequest: \(error.localizedDescription)")
    }
}
