//
//  AdManagerViewController.swift
//  nimbus-ios-sample
//
//  Created on 11/11/21.
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
    private var adController: AdController?
    private lazy var requestManager = NimbusRequestManager()
    private var hasCompanionAd = false
    
    
    deinit {
        adController?.destroy()
        resetVideoSettings()
    }
    
    init(adType: AdManagerAdType, headerSubTitle: String) {
        self.adType = adType
        super.init(headerTitle: adType.description, headerSubTitle: headerSubTitle)
        NimbusRequestManager.requestInterceptors?.append(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupContentView()
        setupAdRendering()
        setupCustomVideoSettings()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NimbusRequestManager.requestInterceptors?.removeAll { $0 === self }
    }
    
    private func setupContentView() {
        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: Constants.headerOffset),
            contentView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            contentView.widthAnchor.constraint(greaterThanOrEqualToConstant: 320),
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),
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
            if UIDevice.nimbusIsLandscape {
                NSLayoutConstraint.activate([
                    contentView.widthAnchor.constraint(equalToConstant: CGFloat(NimbusAdDimensions.landscapeInlineAd.width)),
                    contentView.heightAnchor.constraint(equalToConstant: CGFloat(NimbusAdDimensions.landscapeInlineAd.height)),
                ])
            } else {
                NSLayoutConstraint.activate([
                    contentView.widthAnchor.constraint(equalToConstant: CGFloat(NimbusAdDimensions.portraitInlineAd.width)),
                    contentView.heightAnchor.constraint(equalToConstant: CGFloat(NimbusAdDimensions.portraitInlineAd.height)),
                ])
            }

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
        case .interstitialVideo, .interstitialVideoWithoutUI:
            // See setupCustomVideoSettings() where custom video settings is passed
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
        }
    }
    
    override func didReceiveNimbusEvent(controller: AdController, event: NimbusEvent) {
        super.didReceiveNimbusEvent(controller: controller, event: event)
        
        switch event {
        case .loaded:
            controller.adView?.makeWebViewInspectable()
        case .loadedCompanionAd:
            hasCompanionAd = true
        case .completed:
            if hasCompanionAd {
                // Ensures companion ad view is present
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    if let companionAdView = controller.adView?.subviews.last {
                        companionAdView.makeWebViewInspectable()
                    }
                }
            }
        default:
            break
        }
    }
    
    private func setupCustomVideoSettings() {
        if let videoRenderer = Nimbus.shared.renderers.first(
            where: { $0.key.type == .video }
        )?.value as? NimbusVideoAdRenderer {
            videoRenderer.videoAdSettingsProvider = CustomVideoAdSettingsProvider(disableUi: adType == .interstitialVideoWithoutUI)
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
            try! Nimbus.load(ad: ad, container: contentView, adPresentingViewController: self, delegate: self)
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
    
    public var disableUi: Bool
    
    init(disableUi: Bool = false) {
        self.disableUi = disableUi
    }
    
    override func adsRenderingSettings() -> IMAAdsRenderingSettings {
        let settings = super.adsRenderingSettings()
        settings.disableUi = disableUi
        settings.uiElements = disableUi ? [] : nil // Passing nil shows all of the default UI elements
        return settings
    }
}
