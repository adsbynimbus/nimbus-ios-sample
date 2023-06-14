//
//  AdManagerViewController.swift
//  nimbus-ios-sample
//
//  Created by Victor Takai on 11/11/21.
//

import GoogleInteractiveMediaAds
import NimbusKit
import NimbusRenderVideoKit
import UIKit
import SwiftUI

final class AdManagerViewController: SampleAdViewController {
    private let contentView = UIView()
    private var adManager = NimbusAdManager()
    
    private let adType: AdManagerAdType
    private var customAdContainerView: CustomAdContainerView?
    private var adController: AdController?
    private lazy var requestManager = NimbusRequestManager()
    
    init(adType: AdManagerAdType, headerSubTitle: String) {
        self.adType = adType

        super.init(headerTitle: adType.description, headerSubTitle: headerSubTitle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add self as an interceptor to remove all Demand information to ensure only Nimbus renders
        NimbusRequestManager.requestInterceptors?.append(self)
        
        setupContentView()
        setupAdRendering()
    }
    
    deinit {
        NimbusRequestManager.requestInterceptors?.removeAll(where: { $0 === self })
        CustomVideoAdSettingsProvider.shared.disableUi = false
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
            contentView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    
    private func setupAdRendering() {
        adManager.delegate = self
        switch adType {
                     
        case .manuallyRenderedAd:
            requestManager.delegate = self
            requestManager.performRequest(request: NimbusRequest.forBannerAd(position: adType.description))
        case .banner:
            adManager.showAd(
                request: NimbusRequest.forBannerAd(position: adType.description),
                container: contentView,
                adPresentingViewController: self
            )
        case .bannerWithRefresh:
            adManager.showAd(
                request: NimbusRequest.forBannerAd(position: adType.description),
                container: contentView,
                refreshInterval: 30,
                adPresentingViewController: self
            )
        case .inlineVideo:
            NSLayoutConstraint.activate([
                contentView.heightAnchor.constraint(equalToConstant: 480),
                contentView.widthAnchor.constraint(equalToConstant: 320),
            ])
            adManager.showAd(
                request: NimbusRequest.forVideoAd(position: adType.description),
                container: contentView,
                adPresentingViewController: self
            )
        case .interstitialHybrid:
            adManager.showBlockingAd(
                request: NimbusRequest.forInterstitialAd(position: adType.description),
                adPresentingViewController: self
            )
        case .interstitialStatic:
            let request = NimbusRequest.forInterstitialAd(position: adType.description)
            request.impressions[0].video = nil
            adManager.showBlockingAd(
                request: request,
                closeButtonDelay: 0,
                adPresentingViewController: self
            )
        case .interstitialVideoWithoutUI:
            CustomVideoAdSettingsProvider.shared.disableUi = true
            fallthrough
        case .interstitialVideo:
            let request = NimbusRequest.forInterstitialAd(position: adType.description)
            request.impressions[0].banner = nil
            adManager.showBlockingAd(
                request: request,
                closeButtonDelay: 0,
                adPresentingViewController: self
            )
        case .rewardedVideo:
            adManager.showRewardedAd(
                request: NimbusRequest.forRewardedVideo(position: adType.description),
                adPresentingViewController: self
            )
        case .interstitialStaticWithSKOverlay:
            let request = NimbusRequest.forInterstitialAd(position: adType.description)
            if NimbusAdManager.additionalRequestHeaders == nil {
                NimbusAdManager.additionalRequestHeaders = [:]
            }
            NimbusAdManager.additionalRequestHeaders?["Nimbus-Test-SKOverlay"] = "1"
            request.impressions[0].video = nil
            adManager.showBlockingAd(
                request: request,
                closeButtonDelay: 0,
                adPresentingViewController: self
            )
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NimbusAdManager.additionalRequestHeaders?.removeValue(forKey: "Nimbus-Test-SKOverlay")
    }
    
    override func didReceiveNimbusEvent(controller: AdController, event: NimbusEvent) {
        super.didReceiveNimbusEvent(controller: controller, event: event)
        
        if let ad = nimbusAd, event == .loaded {
            controller.adView?.setUiTestIdentifiers(for: ad, refreshing: adType == .bannerWithRefresh)
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
    func didCompleteNimbusRequest(request: NimbusRequest, ad: NimbusAd) {
        print("didCompleteNimbusRequest")
        nimbusAd = ad
        if ad.position == AdManagerAdType.manuallyRenderedAd.rawValue {
            customAdContainerView = CustomAdContainerView(ad: ad, viewController: self, delegate: self)
            setupAdView(adView: customAdContainerView)
        }
    }

    func didFailNimbusRequest(request: NimbusRequest, error: NimbusError) {
        print("didFailNimbusRequest: \(error.localizedDescription)")
    }
    
    func didRenderAd(request: NimbusRequest, ad: NimbusAd, controller: AdController) {
        print("didRenderAd")
        controller.delegate = self
        adController = controller
    }
}

extension AdManagerViewController : NimbusRequestInterceptor {
    
    func modifyRequest(request: NimbusRequestKit.NimbusRequest) {
        request.user?.extensions?.removeValue(forKey: "vungle_buyeruid")
        request.user?.extensions?.removeValue(forKey: "unity_buyeruid")
        request.user?.extensions?.removeValue(forKey: "facebook_buyeruid")
        request.impressions[0].extensions?.removeValue(forKey: "facebook_app_id")
    }
    
    func didCompleteNimbusRequest(with ad: NimbusAd) { }
    func didFailNimbusRequest(with error: NimbusError) { }
}

final class CustomVideoAdSettingsProvider: NimbusVideoSettingsProvider {
    
    static let shared = CustomVideoAdSettingsProvider()
    
    public var disableUi = false
    
    override func adsRenderingSettings() -> IMAAdsRenderingSettings {
        let settings = IMAAdsRenderingSettings()
        settings.disableUi = disableUi
        if disableUi {
            settings.uiElements = []
        }
        return settings
    }
}
