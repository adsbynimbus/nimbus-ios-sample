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

class VungleViewController: SampleAdViewController {
    
    private let contentView = UIView()
    private let nativeAdContentView = UIView()
    
    private let adType: VungleSample
    
    private var inlineAd: InlineAd?
    private var rewardedAd: RewardedAd?
    private var interstitialAd: InterstitialAd?
    
    init(adType: VungleSample, headerSubTitle: String) {
        self.adType = adType
        
        super.init(headerTitle: adType.description, headerSubTitle: headerSubTitle, enabledExtension: VungleExtension.self)
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
        
        Task {
            do {
                try await setupAdRendering()
            } catch {
                Nimbus.Log.ad.error("Failed to show Vungle ad: \(error.localizedDescription)")
            }
        }
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
    
    private func setupAdRendering() async throws {
        switch adType {
            
        case .vungleBanner:
            inlineAd = try await Nimbus.bannerAd(position: "TEST_BANNER", refreshInterval: 30).show(in: contentView)
        case .vungleMREC:
            inlineAd = try await Nimbus.bannerAd(position: "TEST_MREC", size: .mrec, refreshInterval: 30)
                .show(in: contentView)
        case .vungleInterstitial:
            interstitialAd = try await Nimbus.interstitialAd(position: "TEST_INTERSTITIAL_NOT_SKIPPABLE").show(in: self)
        case .vungleRewarded:
            rewardedAd = try await Nimbus.rewardedAd(position: "TEST_REWARDED").show(in: self)
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
            
            inlineAd = try await Nimbus.nativeAd(position: "TEST_NATIVE").show(in: nativeAdContentView)
        }
    }
}
