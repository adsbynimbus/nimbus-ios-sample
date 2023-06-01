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

final class AdManagerViewController: DemoViewController {
    private let contentView = UIView()
    private var adManager = NimbusAdManager()
    private let screenLogger = Logger()
    private weak var loggerView: UIView?
    
    private let adType: AdManagerAdType
    private let shouldHideVideoUI: Bool
    private var customAdContainerView: CustomAdContainerView?
    private var adController: AdController?
    private var manualRequest: NimbusRequest?
    private var requestManager: NimbusRequestManager?
    private var nimbusAd: NimbusAd?

    init(
        adType: AdManagerAdType,
        headerTitle: String,
        headerSubTitle: String,
        shouldShowVideoUI: Bool = false
    ) {
        self.adType = adType
        self.shouldHideVideoUI = shouldShowVideoUI
        super.init(headerTitle: headerTitle, headerSubTitle: headerSubTitle)
    }
    
    init(adType: AdManagerAdType, headerSubTitle: String, shouldShowVideoUI: Bool = false) {
        self.adType = adType
        self.shouldHideVideoUI = shouldShowVideoUI

        super.init(headerTitle: adType.description, headerSubTitle: headerSubTitle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add self as an interceptor to remove all Demand information to ensure only Nimbus renders
        NimbusRequestManager.requestInterceptors?.append(self)
        
        if shouldHideVideoUI {
            CustomVideoAdSettingsProvider.shared.disableUi = true
        }
        
        setupContentView()
        setupAdRendering()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let logView = loggerView {
            view.sendSubviewToBack(logView)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NimbusRequestManager.requestInterceptors?.removeAll(where: { $0 === self })
        CustomVideoAdSettingsProvider.shared.disableUi = false
        let nimbusAdView = contentView.subviews.first(where: { $0 is NimbusAdView }) as? NimbusAdView
        nimbusAdView?.destroy()
        customAdContainerView?.destroy()
        
        adController?.destroy()
    }

    private func setupContentView() {
        let childView = UIHostingController(rootView: ScreenLogger().environmentObject(screenLogger))
        childView.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(childView)
        view.addSubview(childView.view)
    
        NSLayoutConstraint.activate([
            childView.view.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            childView.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            childView.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            childView.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
        childView.didMove(toParent: self)
        loggerView = childView.view
        
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
            // Manual Request Ad
            manualRequest = NimbusRequest.forBannerAd(position: adType.description)
            
            // Manual Render Ad
            requestManager = NimbusRequestManager()
            requestManager?.delegate = self
            requestManager?.performRequest(request: manualRequest!)
            
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
        case .interstitialStatic, .interstitialVideo, .interstitialVideoWithoutUI:
            let request = NimbusRequest.forInterstitialAd(position: adType.description)
            if adType == .interstitialStatic {
                request.impressions[0].video = nil
            } else if adType == .interstitialVideo || adType == .interstitialVideoWithoutUI {
                request.impressions[0].banner = nil
            }

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
        controller.delegate = self
        adController = controller
    }
}

// MARK: NimbusRequestManagerDelegate

extension AdManagerViewController: NimbusRequestManagerDelegate {
    
    func didCompleteNimbusRequest(request: NimbusRequest, ad: NimbusAd) {
        print("didCompleteNimbusRequest")
        nimbusAd = ad
        if manualRequest == request {
            customAdContainerView = CustomAdContainerView(ad: ad, viewController: self)
            setupAdView(adView: customAdContainerView)
        }
    }

    func didFailNimbusRequest(request: NimbusRequest, error: NimbusError) {
        print("didFailNimbusRequest: \(error.localizedDescription)")
    }
}

extension AdManagerViewController: AdControllerDelegate {
    func didReceiveNimbusEvent(controller: AdController, event: NimbusEvent) {
        if let ad = nimbusAd, event == .loaded {
            screenLogger.logRender(ad)
            controller.adView?.setUiTestIdentifiers(for: ad, refreshing: adType == .bannerWithRefresh)
        }
        screenLogger.logEvent(event)
    }
    
    func didReceiveNimbusError(controller: AdController, error: NimbusError) {
        screenLogger.logError(error)
    }
}

extension AdManagerViewController : NimbusRequestInterceptor {
    
    func modifyRequest(request: NimbusRequestKit.NimbusRequest) {
        request.user?.extensions?.removeValue(forKey: "vungle_buyeruid")
        request.user?.extensions?.removeValue(forKey: "unity_buyeruid")
        request.user?.extensions?.removeValue(forKey: "facebook_buyeruid")
        request.impressions[0].extensions?.removeValue(forKey: "facebook_app_id")
    }
    
    func didCompleteNimbusRequest(with ad: NimbusCoreKit.NimbusAd) { }
    func didFailNimbusRequest(with error: NimbusCoreKit.NimbusError) { }
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
