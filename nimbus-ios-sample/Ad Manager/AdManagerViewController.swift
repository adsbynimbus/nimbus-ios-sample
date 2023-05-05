//
//  AdManagerViewController.swift
//  nimbus-ios-sample
//
//  Created by Victor Takai on 11/11/21.
//

import UIKit
import NimbusKit
import NimbusRenderVideoKit
import GoogleInteractiveMediaAds

#if canImport(NimbusSDK)
import NimbusSDK
#endif

#if canImport(NimbusRenderStaticKit)
import NimbusRenderStaticKit
#endif

final class AdManagerViewController: DemoViewController {
    
    private let contentView = UIView()
    
    private let adType: AdManagerAdType
    private let shouldShowVideoUI: Bool
    private var adManager: NimbusAdManager?
    private var customAdContainerView: CustomAdContainerView?
    private var adController: AdController?
    private var manualRequest: NimbusRequest?
    private var requestManager: NimbusRequestManager?

    init(
        adType: AdManagerAdType,
        headerTitle: String,
        headerSubTitle: String,
        shouldShowVideoUI: Bool = false
    ) {
        self.adType = adType
        self.shouldShowVideoUI = shouldShowVideoUI
        
        super.init(headerTitle: headerTitle, headerSubTitle: headerSubTitle)
    }
    
    init(adType: AdManagerAdType, headerSubTitle: String, shouldShowVideoUI: Bool = false) {
        self.adType = adType
        self.shouldShowVideoUI = shouldShowVideoUI

        super.init(headerTitle: adType.description, headerSubTitle: headerSubTitle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if shouldShowVideoUI {
            setupCustomVideoSettings()
        }
        
        setupContentView()
        setupAdRendering()
    }
    
    deinit {
        if shouldShowVideoUI {
            resetVideoSettings()
        }
        
        let nimbusAdView = contentView.subviews.first(where: { $0 is NimbusAdView }) as? NimbusAdView
        nimbusAdView?.destroy()
        customAdContainerView?.destroy()
        
        adController?.destroy()
    }
    
    private func setupContentView() {
        view.addSubview(contentView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            contentView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor),
            contentView.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func setupAdRendering() {
        switch adType {
                     
        case .manualRequestRenderAd:
            // Manual Request Ad
            manualRequest = NimbusRequest.forBannerAd(position: "test_manual_request_banner")
            
            // Manual Render Ad
            requestManager = NimbusRequestManager()
            requestManager?.delegate = self
            requestManager?.performRequest(request: manualRequest!)
            
        case .banner:
            let request = NimbusRequest.forBannerAd(position: "test_banner")

            adManager = NimbusAdManager()
            adManager?.delegate = self
            adManager?.showAd(
                request: request,
                container: contentView,
                adPresentingViewController: self
            )
        
        case .refreshingBanner:
            let request = NimbusRequest.forBannerAd(position: "refreshing_banner")
            
            adManager = NimbusAdManager()
            adManager?.delegate = self
            adManager?.showAd(
                request: request,
                container: view,
                refreshInterval: 30,
                adPresentingViewController: self
            )
            
        case .video:
            let request = NimbusRequest.forInterstitialAd(position: "test_video")
            request.impressions[0].banner = nil
            
            adManager = NimbusAdManager()
            adManager?.delegate = self
            adManager?.showAd(
                request: request,
                container: view,
                adPresentingViewController: self
            )
            
        case .interstitialStatic, .interstitialVideo, .interstitialVideoWithUI, .interstitialHybrid:
            let request = NimbusRequest.forInterstitialAd(position: "test_interstitial")
            if adType == .interstitialStatic {
                request.impressions[0].video = nil
            } else if adType == .interstitialVideo || adType == .interstitialVideoWithUI {
                request.impressions[0].banner = nil
            }

            adManager = NimbusAdManager()
            adManager?.delegate = self
            adManager?.showBlockingAd(
                request: request,
                closeButtonDelay: 0,
                adPresentingViewController: self
            )
            
        case .rewardedStatic:
            let request = NimbusRequest.forInterstitialAd(position: "test_rewarded_static")
            request.impressions[0].video = nil
            
            adManager = NimbusAdManager()
            adManager?.delegate = self
            adManager?.showRewardedAd(request: request, adPresentingViewController: self)
                        
        case .rewardedVideo:
            adManager = NimbusAdManager()
            adManager?.delegate = self
            adManager?.showRewardedAd(
                request: NimbusRequest.forVideoAd(position: "test_rewarded_video"),
                adPresentingViewController: self
            )
        }
    }
    
    private func setupAdView(adView: CustomAdContainerView?) {
        guard let adView else { return }
        contentView.addSubview(adView)

        adView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            adView.topAnchor.constraint(equalTo: contentView.topAnchor),
            adView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor),
            adView.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor),
            adView.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor),
            adView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
    }
    
    private func setupCustomVideoSettings() {
        if let videoRenderer = Nimbus.shared.renderers.first(
            where: { $0.key.type == .video }
        )?.value as? NimbusVideoAdRenderer {
            videoRenderer.videoAdSettingsProvider = CustomVideoAdSettingsProvider()
        }
    }
    
    private func resetVideoSettings() {
        if let videoRenderer = Nimbus.shared.renderers.first(
            where: { $0.key.type == .video }
        )?.value as? NimbusVideoAdRenderer {
            videoRenderer.videoAdSettingsProvider = NimbusVideoSettingsProvider()
        }
    }
}

// MARK: NimbusAdManagerDelegate

extension AdManagerViewController: NimbusAdManagerDelegate {
    func didRenderAd(request: NimbusRequest, ad: NimbusAd, controller: AdController) {
        print("didRenderAd")
        adController = controller
    }
}

// MARK: NimbusRequestManagerDelegate

extension AdManagerViewController: NimbusRequestManagerDelegate {
    
    func didCompleteNimbusRequest(request: NimbusRequest, ad: NimbusAd) {
        print("didCompleteNimbusRequest")
        
        if manualRequest == request {
            customAdContainerView = CustomAdContainerView(ad: ad, viewController: self)
            customAdContainerView?.accessibilityIdentifier = "adManagerManualRequestRenderAdView"
            setupAdView(adView: customAdContainerView)
        }
    }

    func didFailNimbusRequest(request: NimbusRequest, error: NimbusError) {
        print("didFailNimbusRequest: \(error.localizedDescription)")
    }
}

final class CustomVideoAdSettingsProvider: NimbusVideoSettingsProvider {
    override func adsRenderingSettings() -> IMAAdsRenderingSettings {
        let settings = IMAAdsRenderingSettings()
        settings.disableUi = false
        return settings
    }
}
