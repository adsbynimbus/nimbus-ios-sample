//
//  GAMViewController.swift
//  nimbus-ios-sample
//
//  Created by Victor Takai on 16/11/21.
//

import UIKit
import NimbusKit
import NimbusSDK
import GoogleMobileAds

final class GAMViewController: DemoViewController {
    
    private let adType: MediationAdType
    private let requestManager = NimbusRequestManager()
    private var bannerView: GAMBannerView!
    private var interstitial: GADInterstitialAd!
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
            bannerView.rootViewController = self
            bannerView.adUnitID = ConfigManager.shared.googlePlacementId
            bannerView.delegate = self
            
            bannerView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(bannerView)
            
            NSLayoutConstraint.activate([
                bannerView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
                bannerView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
            ])
            bannerView.load(gamRequest)
            
        case .dynamicPriceBanner:
            bannerView = GAMBannerView(adSize: GADAdSizeBanner)
            bannerView.rootViewController = self
            bannerView.adUnitID = ConfigManager.shared.googlePlacementId
            bannerView.delegate = self
            
            bannerView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(bannerView)
            NSLayoutConstraint.activate([
                bannerView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
                bannerView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
            ])
            
            gamDynamicPrice = NimbusGAMDynamicPrice(request: gamRequest)
            gamDynamicPrice?.requestDelegate = self
            
            requestManager.delegate = gamDynamicPrice
            requestManager.performRequest(request: NimbusRequest.forBannerAd(position: "banner_position"))
            
        case .interstitial:
            GAMInterstitialAd.load(
                withAdManagerAdUnitID: ConfigManager.shared.googlePlacementId!,
                request: gamRequest
            ) { (ad, error) in
                if let error = error {
                    print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                    return
                }
                self.interstitial = ad
                self.interstitial.fullScreenContentDelegate = self
                ad?.present(fromRootViewController: self)
            }
            
        case .dynamicPriceInterstitial:
            gamDynamicPrice = NimbusGAMDynamicPrice(request: gamRequest)
            gamDynamicPrice?.requestDelegate = self
            
            requestManager.delegate = gamDynamicPrice
            requestManager.performRequest(request: NimbusRequest.forInterstitialAd(position: "interstitial_position"))
            
        case .dynamicPriceInterstitialStatic:
            gamDynamicPrice = NimbusGAMDynamicPrice(request: gamRequest)
            gamDynamicPrice?.requestDelegate = self
            
            requestManager.delegate = gamDynamicPrice
            
            let request = NimbusRequest.forInterstitialAd(position: "interstitial_static_position")
            request.impressions[0].video = nil
            
            requestManager.performRequest(request: request)
            
        case .dynamicPriceInterstitialVideo:
            gamDynamicPrice = NimbusGAMDynamicPrice(request: gamRequest)
            gamDynamicPrice?.requestDelegate = self
            
            requestManager.delegate = gamDynamicPrice
            
            let request = NimbusRequest.forInterstitialAd(position: "interstitial_video_position")
            request.impressions[0].banner = nil
            
            requestManager.performRequest(request: request)
        }
    }
}

// MARK: - GADBannerViewDelegate

extension GAMViewController: GADBannerViewDelegate {
    
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("bannerViewDidReceiveAd")
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
    
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("adWillPresentFullScreenContent")
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("adDidDismissFullScreenContent")
    }
}

// MARK: - NimbusRequestManagerDelegate

extension GAMViewController: NimbusRequestManagerDelegate {
    
    func didCompleteNimbusRequest(request: NimbusRequest, ad: NimbusAd) {
        print("didCompleteNimbusRequest")
        
        if adType == .dynamicPriceBanner {
            bannerView.load(gamRequest)
        } else {
            GADInterstitialAd.load(
                withAdUnitID: ConfigManager.shared.googlePlacementId!,
                request: gamRequest
            ) { gadAd, error in
                if let error = error {
                    print("Failed to load dynamic price interstitial ad with error: \(error.localizedDescription)")
                    return
                }
                self.interstitial = gadAd
                self.interstitial.fullScreenContentDelegate = self
                
                gadAd?.present(fromRootViewController: self)
            }
        }
    }
    
    
    func didFailNimbusRequest(request: NimbusRequest, error: NimbusError) {
        print("didFailNimbusRequest: \(error.localizedDescription)")
    }
}
