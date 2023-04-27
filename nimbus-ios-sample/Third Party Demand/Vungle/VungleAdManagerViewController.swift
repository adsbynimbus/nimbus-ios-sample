//
//  VungleAdManagerViewController.swift
//  NimbusInternalSampleApp
//
//  Created by Bruno Bruggemann on 10/25/22.
//  Copyright © 2022 Timehop. All rights reserved.
//

import UIKit
import NimbusKit
import AdSupport

class VungleAdManagerViewController: DemoViewController {
    
    private let contentView = UIView()
    
    private let adType: VungleAdType
    private var adManager: NimbusAdManager!
    private var adController: AdController?
    
    init(adType: VungleAdType, headerTitle: String, headerSubTitle: String) {
        self.adType = adType
        
        super.init(headerTitle: headerTitle, headerSubTitle: headerSubTitle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        let request = createNimbusRequest(adType: adType)
        
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
            adManager.showRewardedAd(
                request: request,
                adPresentingViewController: self
            )
        }
    }
    
    private func createNimbusRequest(adType: VungleAdType) -> NimbusRequest {
        switch adType {
            
        case .vungleBanner:
            let request = NimbusRequest.forBannerAd(
                position: ConfigManager.shared.vungleBannerPlacementId,
                format: .banner320x50
            )
            request.impressions[0].banner?.position = NimbusPosition.unknown
            return request
        case .vungleMREC:
            return NimbusRequest.forBannerAd(
                position: ConfigManager.shared.vungleMRECPlacementId,
                format: .letterbox
            )
        case .vungleInterstitial:
            return NimbusRequest.forInterstitialAd(
                position: ConfigManager.shared.vungleInterstitialPlacementId
            )
        case .vungleRewarded:
            return customNimbusRequestForRewardedVideo(
                position: ConfigManager.shared.vungleRewardedPlacementId
            )
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

extension VungleAdManagerViewController: NimbusAdManagerDelegate {
    func didRenderAd(request: NimbusRequest, ad: NimbusAd, controller: AdController) {
        print("didRenderAd")
        
        adController = controller
        adController?.delegate = self
    }
}

// MARK: NimbusRequestManagerDelegate

extension VungleAdManagerViewController: NimbusRequestManagerDelegate {
    
    func didCompleteNimbusRequest(request: NimbusRequest, ad: NimbusAd) {
        print("didCompleteNimbusRequest")
    }
    
    func didFailNimbusRequest(request: NimbusRequest, error: NimbusError) {
        print("didFailNimbusRequest: \(error.localizedDescription)")
    }
}

extension VungleAdManagerViewController: AdControllerDelegate {
    
    func didReceiveNimbusEvent(controller: NimbusCoreKit.AdController, event: NimbusCoreKit.NimbusEvent) {
        print("Nimbus didReceiveNimbusEvent: \(event)")
    }
    
    func didReceiveNimbusError(controller: NimbusCoreKit.AdController, error: NimbusCoreKit.NimbusError) {
        print("Nimbus didReceiveNimbusError: \(error)")
    }
}
