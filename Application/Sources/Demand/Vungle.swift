//
//  VungleViewController.swift
//  nimbus-ios-sample
//
//  Created on 10/25/22.
//  Copyright © 2022 Nimbus Advertising Solutions Inc. All rights reserved.
//

import AdSupport
import NimbusKit
#if canImport(NimbusSDK) // CocoaPods
import NimbusSDK
#else                    // Swift Package Manager
import NimbusVungleKit
#endif
import UIKit
import VungleAdsSDK

class VungleViewController: DemandViewController {
    
    private let contentView = UIView()
    private let nativeAdContentView = UIView()
    
    private let adType: VungleSample
    private var adManager: NimbusAdManager?
    private var adController: AdController?
    
    init(adType: VungleSample, headerSubTitle: String) {
        self.adType = adType
        
        super.init(network: .vungle, headerTitle: adType.description, headerSubTitle: headerSubTitle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        VungleExtension.nativeViewProvider = { (container, nativeAd) in
            NimbusVungleNativeAdView(nativeAd)
        }
        
        setupContentView()
        setupAdRendering()
    }
    
    private func setupContentView() {
        view.addSubview(contentView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func setupAdRendering() {
        adManager = NimbusAdManager()
        adManager?.delegate = self
        
        switch adType {
            
        case .vungleBanner:
            adManager?.showAd(
                request: NimbusRequest.forBannerAd(position: "TEST_BANNER", format: .banner320x50),
                container: contentView,
                refreshInterval: 30,
                adPresentingViewController: self
            )
        case .vungleMREC:
            adManager?.showAd(
                request: NimbusRequest.forBannerAd(position: "TEST_MREC", format: .letterbox),
                container: contentView,
                adPresentingViewController: self
            )
        case .vungleInterstitial:
            adManager?.showBlockingAd(
                request: NimbusRequest.forInterstitialAd(position: "TEST_INTERSTITIAL_NOT_SKIPPABLE"),
                adPresentingViewController: self
            )
        case .vungleRewarded:
            adManager?.showRewardedAd(
                request: NimbusRequest.forRewardedVideo(position: "TEST_REWARDED"),
                adPresentingViewController: self
            )
        case .vungleNative:
            nativeAdContentView.translatesAutoresizingMaskIntoConstraints = false
            
            contentView.addSubview(nativeAdContentView)
            
            NSLayoutConstraint.activate([
                nativeAdContentView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                nativeAdContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                nativeAdContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                nativeAdContentView.widthAnchor.constraint(equalToConstant: 300),
                nativeAdContentView.heightAnchor.constraint(equalToConstant: 300)
            ])
            
            adManager?.showAd(
                request: NimbusRequest.forNativeAd(position: "TEST_NATIVE"),
                container: nativeAdContentView,
                adPresentingViewController: self
            )
        }
    }
}

extension VungleViewController: NimbusAdManagerDelegate {
    func didRenderAd(request: NimbusRequest, ad: NimbusAd, controller: AdController) {
        print("didRenderAd")
        adController = controller
        adController?.register(delegate: self)
        nimbusAd = ad
    }
    
    func didCompleteNimbusRequest(request: NimbusRequest, ad: NimbusAd) {
        print("didCompleteNimbusRequest")
    }
    
    func didFailNimbusRequest(request: NimbusRequest, error: NimbusError) {
        print("didFailNimbusRequest: \(error.localizedDescription)")
    }
}
