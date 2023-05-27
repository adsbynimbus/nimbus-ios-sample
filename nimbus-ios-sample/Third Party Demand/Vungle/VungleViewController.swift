//
//  VungleViewController.swift
//  nimbus-ios-sample
//
//  Created by Bruno Bruggemann on 10/25/22.
//  Copyright © 2022 Timehop. All rights reserved.
//

import AdSupport
import NimbusKit
#if canImport(NimbusSDK) // CocoaPods
import NimbusSDK
#else                    // Swift Package Manager
import NimbusVungleKit
#endif
import UIKit

extension AppDelegate {
    func setupVungleDemand() {
        if let vungleAppId = Bundle.main.infoDictionary?["Vungle App ID"] as? String {
            Nimbus.shared.renderers[.forNetwork("vungle")] = NimbusVungleAdRenderer()
            NimbusRequestManager.requestInterceptors?.append(NimbusVungleRequestInterceptor(appId: vungleAppId, isLoggingEnabled: true))
        }
    }
}

class VungleViewController: DemoViewController {
    
    private let contentView = UIView()
    
    private let adType: VungleSample
    private var adManager: NimbusAdManager?
    private var adController: AdController?
    private var nimbusAd: NimbusAd?
    
    init(adType: VungleSample, headerSubTitle: String) {
        self.adType = adType
        
        super.init(headerTitle: adType.description, headerSubTitle: headerSubTitle)
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
    
    private func createNimbusRequest(adType: VungleSample) -> NimbusRequest? {
        switch adType {
            
        case .vungleBanner:
            let request = NimbusRequest.forBannerAd(
                position: adType.description,
                format: .banner320x50
            )
            request.impressions[0].banner?.position = NimbusPosition.unknown
            return request
            
        case .vungleMREC:
            return NimbusRequest.forBannerAd(
                position: adType.description,
                format: .letterbox
            )
            
        case .vungleInterstitial:
            return NimbusRequest.forInterstitialAd(position: adType.description)
            
        case .vungleRewarded:
            return customNimbusRequestForRewardedVideo(position: adType.description)
            
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
        adController = controller
        adController?.delegate = self
        nimbusAd = ad
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
        if let ad = nimbusAd, event == .loaded {
            controller.adView?.setUiTestIdentifiers(for: ad)
        }
    }
    
    func didReceiveNimbusError(controller: AdController, error: NimbusError) {
        print("Nimbus didReceiveNimbusError: \(error)")
    }
}
