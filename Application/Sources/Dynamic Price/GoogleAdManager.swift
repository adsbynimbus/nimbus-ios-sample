//
//  Google.swift
//  nimbus-ios-sample
//
//  Created by Jason Sznol on 5/27/23.
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

final class GoogleDynamicPriceViewController: DemoViewController {
    
    private let adType: DynamicPriceSample
    private let requestManager = NimbusRequestManager()
    private var bannerView: GAMBannerView?
    private var interstitial: GADInterstitialAd?
    private var gamDynamicPrice: NimbusGAMDynamicPrice?
    private lazy var gamRequest = GAMRequest()
    private var nimbusAd: NimbusAd?
    
    init(adType: DynamicPriceSample, headerSubTitle: String) {
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
        switch adType {
        case .dynamicPriceBanner:
            bannerView = GAMBannerView(adSize: GADAdSizeBanner)
            guard let bannerView else { return }
            bannerView.rootViewController = self
            bannerView.adUnitID = gamPlacementId
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
            bannerView.adUnitID = gamPlacementId
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
        case .dynamicPriceInlineVideo:
            bannerView = GAMBannerView(adSize: GADAdSizeMediumRectangle)
            guard let bannerView else { return }
            bannerView.rootViewController = self
            bannerView.adUnitID = gamPlacementId
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
            
            requestManager.performRequest(request: NimbusRequest.forVideoAd(position: adType.description))
        case .dynamicPriceInterstitial:
            gamDynamicPrice = NimbusGAMDynamicPrice(request: gamRequest)
            gamDynamicPrice?.requestDelegate = self
            
            requestManager.delegate = gamDynamicPrice
            requestManager.performRequest(request: NimbusRequest.forInterstitialAd(position: adType.description))
        }
    }
}

// MARK: - GADBannerViewDelegate

extension GoogleDynamicPriceViewController: GADBannerViewDelegate {
    
    
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("bannerViewDidReceiveAd")
        
        /* Set identifiers for UI testing */
        switch adType {
        case .dynamicPriceBanner, .dynamicPriceInlineVideo, .dynamicPriceBannerVideo:
            if let ad = nimbusAd {
                bannerView.setUiTestIdentifiers(for: ad.testIdentifier, id: "google_ad_view")
            }
        default:
            return
        }
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

extension GoogleDynamicPriceViewController: GADFullScreenContentDelegate {
    
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

extension GoogleDynamicPriceViewController: NimbusRequestManagerDelegate {
    
    func didCompleteNimbusRequest(request: NimbusRequest, ad: NimbusAd) {
        print("didCompleteNimbusRequest with \(ad.auctionType) ad type")
        nimbusAd = ad
        if adType != .dynamicPriceInterstitial{
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
