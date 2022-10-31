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
    
    deinit {
        let nimbusAdView = contentView.subviews.first(where: { $0 is NimbusAdView }) as? NimbusAdView
        nimbusAdView?.destroy()
        
        adController?.destroy()
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
            adManager?.showAd(request: request,
                              container: contentView,
                              adPresentingViewController: self)
        case .vungleMREC:
            let mrecView = UIView()
            mrecView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(mrecView)
            
            NSLayoutConstraint.activate([
                mrecView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                mrecView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                mrecView.widthAnchor.constraint(equalToConstant: 300),
                mrecView.heightAnchor.constraint(equalToConstant: 250)
            ])
            
            adManager?.showAd(request: request, container: mrecView, adPresentingViewController: self)
        case .vungleInterstitial:
            adManager?.showRewardedAd(request: request, closeButtonDelay: 0, adPresentingViewController: self)
        case .vungleRewarded:
            request.impressions[0].banner = nil
            adManager.showBlockingAd(request: request, adPresentingViewController: self)
        }
    }
    
    private func createNimbusRequest(adType: VungleAdType) -> NimbusRequest {
        switch adType {
            
        case .vungleBanner:
            let request = NimbusRequest.forBannerAd(position: ConfigManager.shared.vungleBannerPlacementId ?? "",
                                                    format: .banner320x50)
            request.impressions[0].banner?.position = NimbusPosition.unknown
            return request
        case .vungleMREC:
            return NimbusRequest.forBannerAd(position: ConfigManager.shared.vungleMRECPlacementId ?? "",
                                             format: .letterbox)
        case .vungleInterstitial:
            return NimbusRequest.forInterstitialAd(position: ConfigManager.shared.vungleInterstitialPlacementId ?? "")
        case .vungleRewarded:
            return customNimbusRequestForRewardedVideo(position: ConfigManager.shared.vungleRewardedPlacementId ?? "")
        }
    }
    
    // Used to force the backend to return a Rewarded Ad.
    private func customNimbusRequestForRewardedVideo(position: String) -> NimbusRequest {
        var impression = NimbusImpression(
            // Video width and height are set to the container width and height after the container is sent
            video: NimbusVideo.interstitial(),
            isInterstitial: true
        )
        impression.position = position
        if impression.video?.extensions == nil { impression.video?.extensions = [:] }
        impression.video?.extensions?["is_rewarded"] = 1
        
        let adFormat = NimbusAdFormat.halfScreen
        let banner = NimbusBanner(
            width: adFormat.width,
            height: adFormat.height,
            companionAdRenderMode: .endCard
        )
        impression.video?.companionAds = [banner]
        
        let device = NimbusDevice(
            userAgent: Nimbus.shared.userAgentString,
            limitAdTracking: false,
            deviceType: .mobileOrTablet,
            make: "apple",
            model: UIDevice.current.nimbusModelName,
            operatingSystem: "ios",
            operatingSystemVersion: UIDevice.current.systemVersion,
            width: Int(UIScreen.main.bounds.width),
            height: Int(UIScreen.main.bounds.height),
            connectionType: Nimbus.shared.connectionType,
            advertisingId: ASIdentifierManager.shared().nimbusAdId()
        )
        
        return NimbusRequest(
            impressions: [impression],
            device: device,
            format: adFormat
        )
    }
}

// MARK: NimbusAdManagerDelegate

extension VungleAdManagerViewController: NimbusAdManagerDelegate {
    func didRenderAd(request: NimbusRequest, ad: NimbusAd, controller: AdController) {
        print("didRenderAd")
        adController = controller
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
