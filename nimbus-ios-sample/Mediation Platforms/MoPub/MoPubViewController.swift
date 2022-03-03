//
//  MoPubViewController.swift
//  nimbus-ios-sample
//
//  Created by Victor Takai on 16/11/21.
//

import UIKit
import NimbusRequestKit
import MoPubSDK

#if canImport(NimbusSDK)
import NimbusSDK
#endif

#if canImport(NimbusMopubKit)
import NimbusMopubKit
#endif

final class MopubViewController: DemoViewController {
    
    private let adType: MediationAdType
    private var adView: MPAdView!
    private var adViewController: MPInterstitialAdController!
    private var requestManager: NimbusRequestManager?
    private var mopubDynamicPrice: NimbusMopubDynamicPrice?

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
            adView = MPAdView(adUnitId: ConfigManager.shared.mopubBannerId)
            adView.accessibilityIdentifier = "mopubMPAdView"
            adView.translatesAutoresizingMaskIntoConstraints = false
            adView.delegate = self
            adView.stopAutomaticallyRefreshingContents()
            adView.frame = CGRect(x: 0, y: 0, width: 320, height: 50)
            view.addSubview(adView)

            NSLayoutConstraint.activate([
                adView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                adView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                adView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
                adView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
                adView.heightAnchor.constraint(equalToConstant: 50)
            ])
            
            adView.loadAd(withMaxAdSize: kMPPresetMaxAdSize50Height)
            
        case .dynamicPriceBanner:
            adView = MPAdView(adUnitId: ConfigManager.shared.mopubBannerId)
            adView.accessibilityIdentifier = "mopubDynamicPriceMPAdView"
            adView.translatesAutoresizingMaskIntoConstraints = false
            adView.delegate = self
            adView.stopAutomaticallyRefreshingContents()
            adView.frame = CGRect(x: 0, y: 0, width: 320, height: 50)
            view.addSubview(adView)

            NSLayoutConstraint.activate([
                adView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                adView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                adView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
                adView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
                adView.heightAnchor.constraint(equalToConstant: 50)
            ])
            
            mopubDynamicPrice = NimbusMopubDynamicPrice(target: adView, mapping: TestDynamicPriceMapping())
            mopubDynamicPrice?.requestDelegate = self
            
            requestManager = NimbusRequestManager()
            requestManager?.delegate = mopubDynamicPrice
            requestManager?.performRequest(request: NimbusRequest.forBannerAd(position: "test_dynamic_price_banner"))
            
        case .interstitial:
            adViewController = MPInterstitialAdController(forAdUnitId: ConfigManager.shared.mopubInterstitialId)
            adViewController.delegate = self
            adViewController.loadAd()
            
        case .dynamicPriceInterstitial:
            adViewController = MPInterstitialAdController(forAdUnitId: ConfigManager.shared.mopubInterstitialId)
            adViewController.delegate = self
            
            mopubDynamicPrice = NimbusMopubDynamicPrice(target: adViewController, mapping: TestDynamicPriceMapping())
            mopubDynamicPrice?.requestDelegate = self
            
            requestManager = NimbusRequestManager()
            requestManager?.delegate = mopubDynamicPrice
            requestManager?.performRequest(request: NimbusRequest.forInterstitialAd(position: "test_dynamic_price_interstitial"))
        }
    }
}

// MARK: MPAdViewDelegate

extension MopubViewController: MPAdViewDelegate {
    func viewControllerForPresentingModalView() -> UIViewController! { self }
}

// MARK: MPInterstitialAdControllerDelegate

extension MopubViewController: MPInterstitialAdControllerDelegate {
    
    func interstitialDidLoadAd(_ interstitial: MPInterstitialAdController!) {
        guard interstitial.ready else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            interstitial.show(from: self)
        })
    }
}

// MARK: NimbusRequestManagerDelegate

extension MopubViewController: NimbusRequestManagerDelegate {
    func didCompleteNimbusRequest(request: NimbusRequest, ad: NimbusAd) {
        print("didCompleteNimbusRequest")
        
        if adType == .dynamicPriceBanner {
            adView.loadAd()
        } else if adType == .dynamicPriceInterstitial {
            adViewController.loadAd()
        }
    }

    func didFailNimbusRequest(request: NimbusRequest, error: NimbusError) {
        print("didFailNimbusRequest: \(error.localizedDescription)")
    }
}

// MARK: TestDynamicPriceMapping

private final class TestDynamicPriceMapping: NimbusDynamicPriceMapping {
    func getKeywords(ad: NimbusAd) -> String? { "na_bid:5" }
}
