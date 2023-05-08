//
//  VungleViewController.swift
//  nimbus-ios-sample
//
//  Created by Bruno Bruggemann on 10/25/22.
//  Copyright © 2022 Timehop. All rights reserved.
//

import UIKit
import NimbusKit
import AdSupport

#if canImport(NimbusSDK)
import NimbusSDK
#endif

#if canImport(NimbusVungleKit)
import NimbusVungleKit
#endif

class VungleViewController: DemoViewController {
    
    private let contentView = UIView()
    
    private let adType: ThirdPartyDemandAdType
    private var adManager: NimbusAdManager?
    private var adController: AdController?
    
    init(adType: ThirdPartyDemandAdType, headerTitle: String, headerSubTitle: String) {
        self.adType = adType
        
        super.init(headerTitle: headerTitle, headerSubTitle: headerSubTitle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupContentView()
        setupRequestInterceptor()
        setupAdRendering()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // For testing purposes, this will clear all request interceptors
        DemoRequestInterceptors.shared.removeRequestInterceptors()
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
    
    private func setupRequestInterceptor() {
        // For testing purposes, this ensures only the required interceptors will be set
        DemoRequestInterceptors.shared.setVungleRequestInterceptor()
    }
    
    private func setupAdRendering() {
        guard let request = createNimbusRequest(adType: adType) else {
            return
        }
        
        adManager = NimbusAdManager()
        adManager?.delegate = self
        
        switch adType {
            
        case .vungleBanner:
            adManager?.showAd(
                request: request,
                container: contentView,
                adPresentingViewController: self
            )
        case .vungleMREC:
            adManager?.showAd(
                request: request,
                container: contentView,
                adPresentingViewController: self
            )
        case .vungleInterstitial:
            adManager?.showBlockingAd(
                request: request,
                closeButtonDelay: 0,
                adPresentingViewController: self
            )
        case .vungleRewarded:
            request.impressions[0].banner = nil
            adManager?.showRewardedAd(
                request: request,
                adPresentingViewController: self
            )
            
        default:
            break
        }
    }
    
    private func createNimbusRequest(adType: ThirdPartyDemandAdType) -> NimbusRequest? {
        switch adType {
            
        case .vungleBanner:
            let request = NimbusRequest.forBannerAd(
                position: ConfigManager.shared.vungleBannerPlacementId!,
                format: .banner320x50
            )
            request.impressions[0].banner?.position = NimbusPosition.unknown
            return request
            
        case .vungleMREC:
            return NimbusRequest.forBannerAd(
                position: ConfigManager.shared.vungleMRECPlacementId!,
                format: .letterbox
            )
            
        case .vungleInterstitial:
            return NimbusRequest.forInterstitialAd(
                position: ConfigManager.shared.vungleInterstitialPlacementId!
            )
            
        case .vungleRewarded:
            return customNimbusRequestForRewardedVideo(
                position: ConfigManager.shared.vungleRewardedPlacementId!
            )
            
        default:
            return nil
        }
    }
    
    // Used to force the backend to return a Rewarded Ad.
    private func customNimbusRequestForRewardedVideo(position: String) -> NimbusRequest {
        let request = NimbusRequest.forRewardedVideo(position: position)
        
        let adFormat = NimbusAdFormat.halfScreen
        request.format = adFormat
        
        let banner = NimbusBanner(
            width: adFormat.width,
            height: adFormat.height,
            companionAdRenderMode: .endCard
        )
        request.impressions[0].video?.companionAds = [banner]
        
        return request
    }
}

// MARK: NimbusAdManagerDelegate

extension VungleViewController: NimbusAdManagerDelegate {
    func didRenderAd(request: NimbusRequest, ad: NimbusAd, controller: AdController) {
        print("didRenderAd")
        controller.adView?.accessibilityIdentifier = "nimbus_ad_view"
        controller.adView?.accessibilityLabel = "\(ad.network) \(ad.auctionType.rawValue) ad"
        adController = controller
        adController?.delegate = self
    }
}

// MARK: NimbusRequestManagerDelegate

extension VungleViewController: NimbusRequestManagerDelegate {
    
    func didCompleteNimbusRequest(request: NimbusRequest, ad: NimbusAd) {
        print("didCompleteNimbusRequest")
    }
    
    func didFailNimbusRequest(request: NimbusRequest, error: NimbusError) {
        print("didFailNimbusRequest: \(error.localizedDescription)")
    }
}

extension VungleViewController: AdControllerDelegate {
    
    func didReceiveNimbusEvent(controller: AdController, event: NimbusEvent) {
        print("Nimbus didReceiveNimbusEvent: \(event)")
    }
    
    func didReceiveNimbusError(controller: AdController, error: NimbusError) {
        print("Nimbus didReceiveNimbusError: \(error)")
    }
}
