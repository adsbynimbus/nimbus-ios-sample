//
//  GAMViewController.swift
//  nimbus-ios-sample
//
//  Created by Victor Takai on 16/11/21.
//

import UIKit
import NimbusKit
import GoogleMobileAds

#if canImport(NimbusSDK)
import NimbusSDK
#endif

#if canImport(NimbusGAMKit)
import NimbusGAMKit
#endif

final class GAMViewController: DemoViewController {
    
    private let adType: MediationAdType
    private let requestManager = NimbusRequestManager()
    private var bannerView: GAMBannerView?
    private var interstitial: GADInterstitialAd?
    private var gamDynamicPrice: NimbusGAMDynamicPrice?
    private lazy var gamRequest = GAMRequest()
    
    init(adType: MediationAdType, headerSubTitle: String) {
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
            
        case .banner:
            bannerView = GAMBannerView(adSize: GADAdSizeBanner)
            guard let bannerView else { return }
            bannerView.rootViewController = self
            bannerView.adUnitID = ConfigManager.shared.googlePlacementId
            bannerView.delegate = self
            bannerView.isAccessibilityElement = true
            bannerView.accessibilityIdentifier = "google_ad_view"
            
            bannerView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(bannerView)
            
            NSLayoutConstraint.activate([
                bannerView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
                bannerView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor),
                bannerView.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor),
                bannerView.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor),
                bannerView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            ])
            bannerView.load(gamRequest)
        case .interstitial:
            GAMInterstitialAd.load(
                withAdManagerAdUnitID: ConfigManager.shared.googlePlacementId!,
                request: gamRequest
            ) { (ad, error) in
                if let error {
                    print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                    return
                }
                self.interstitial = ad
                self.interstitial?.fullScreenContentDelegate = self
                ad?.present(fromRootViewController: self)
            }
        case .dynamicPriceBanner:
            bannerView = GAMBannerView(adSize: GADAdSizeBanner)
            guard let bannerView else { return }
            bannerView.rootViewController = self
            bannerView.adUnitID = ConfigManager.shared.googlePlacementId
            bannerView.delegate = self
            bannerView.accessibilityIdentifier = "google_ad_view"
            
            bannerView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(bannerView)
            view.addConstraints(
                [NSLayoutConstraint(item: bannerView,
                                    attribute: .top,
                                    relatedBy: .equal,
                                    toItem: headerView,
                                    attribute: .bottom,
                                    multiplier: 1,
                                    constant: 0),
                 NSLayoutConstraint(item: bannerView,
                                    attribute: .centerX,
                                    relatedBy: .equal,
                                    toItem: view,
                                    attribute: .centerX,
                                    multiplier: 1,
                                    constant: 0)
            ])
            
            gamDynamicPrice = NimbusGAMDynamicPrice(request: gamRequest)
            gamDynamicPrice?.requestDelegate = self
            
            requestManager.delegate = gamDynamicPrice
            requestManager.performRequest(request: NimbusRequest.forBannerAd(position: adType.description))
        case .dynamicPriceBannerVideo:
            bannerView = GAMBannerView(adSize: GADAdSizeMediumRectangle)
            guard let bannerView else { return }
            bannerView.rootViewController = self
            bannerView.adUnitID = ConfigManager.shared.googlePlacementId
            bannerView.delegate = self
            bannerView.validAdSizes = [NSValueFromGADAdSize(GADAdSizeFromCGSize(CGSize(width: 400, height: 300)))]
            bannerView.accessibilityIdentifier = "google_ad_view"
            
            bannerView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(bannerView)
            view.addConstraints(
                [NSLayoutConstraint(item: bannerView,
                                    attribute: .top,
                                    relatedBy: .equal,
                                    toItem: headerView,
                                    attribute: .bottom,
                                    multiplier: 1,
                                    constant: 0),
                 NSLayoutConstraint(item: bannerView,
                                    attribute: .centerX,
                                    relatedBy: .equal,
                                    toItem: view,
                                    attribute: .centerX,
                                    multiplier: 1,
                                    constant: 0)
            ])
          
            gamDynamicPrice = NimbusGAMDynamicPrice(request: gamRequest)
            gamDynamicPrice?.requestDelegate = self
            
            requestManager.delegate = gamDynamicPrice
            
            let nimbusRequest = NimbusRequest.forBannerAd(position: adType.description, format: NimbusAdFormat.letterbox)
            var video = NimbusVideo.interstitial() /* This helper will return a populated video object */
            video.position = NimbusPosition.unknown /* Remove the fullscreen position set from the interstitial helper */
            nimbusRequest.impressions[0].video = video
            requestManager.performRequest(request: nimbusRequest)
        case .dynamicPriceInterstitial:
            gamDynamicPrice = NimbusGAMDynamicPrice(request: gamRequest)
            gamDynamicPrice?.requestDelegate = self
            
            requestManager.delegate = gamDynamicPrice
            requestManager.performRequest(request: NimbusRequest.forInterstitialAd(position: adType.description))
        }
    }
}

// MARK: - GADBannerViewDelegate

extension GAMViewController: GADBannerViewDelegate {
    
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("bannerViewDidReceiveAd")
      //  bannerView.nimbusAdView?.setUiTestIdentifiers(for: "test_demand static ad")
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

extension GAMViewController: GADFullScreenContentDelegate {
    
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

extension GAMViewController: NimbusRequestManagerDelegate {
    
    func didCompleteNimbusRequest(request: NimbusRequest, ad: NimbusAd) {
        print("didCompleteNimbusRequest with \(ad.auctionType) ad type")
        
        if adType == .dynamicPriceBanner || adType == .dynamicPriceBannerVideo {
            bannerView?.load(gamRequest)
        } else {
            GADInterstitialAd.load(
                withAdUnitID: ConfigManager.shared.googlePlacementId!,
                request: gamRequest
            ) { gadAd, error in
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

extension GADBannerView {
    
    var nimbusAdView: NimbusAdView? {
        var currentView = subviews.first
        while currentView != nil && !(currentView is NimbusAdView){
            currentView = currentView?.subviews.first
        }
        return currentView as? NimbusAdView
    }
}
