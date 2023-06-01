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

fileprivate var shared: NimbusVungleRequestInterceptor?
fileprivate var vungleAppId = Bundle.main.infoDictionary?["Vungle App ID"] as? String

extension UIApplicationDelegate {
    func setupVungleDemand() {
        if let appId = vungleAppId {
            Nimbus.shared.renderers[.forNetwork("vungle")] = NimbusVungleAdRenderer()
            let vungleRequestInterceptor = NimbusVungleRequestInterceptor(appId: appId)
            NimbusRequestManager.requestInterceptors?.append(vungleRequestInterceptor)
            
            // Disable Vungle Ads until we are are on the VungleViewController
            shared = vungleRequestInterceptor
            NimbusVungleRequestInterceptor.enabled = false
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
        
        // Enable Vungle Demand for this screen only
        NimbusVungleRequestInterceptor.enabled = true
        
        setupContentView()
        setupAdRendering()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NimbusVungleRequestInterceptor.enabled = false
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
                request: NimbusRequest.forBannerAd(position: adType.description, format: .banner320x50),
                container: contentView,
                adPresentingViewController: self
            )
        case .vungleMREC:
            adManager?.showAd(
                request: NimbusRequest.forBannerAd(position: adType.description, format: .letterbox),
                container: contentView,
                adPresentingViewController: self
            )
        case .vungleInterstitial:
            adManager?.showBlockingAd(
                request: NimbusRequest.forInterstitialAd(position: adType.description),
                adPresentingViewController: self
            )
        case .vungleRewarded:
            adManager?.showRewardedAd(
                request: NimbusRequest.forRewardedVideo(position: adType.description),
                adPresentingViewController: self
            )
        }
    }
}

extension VungleViewController: NimbusAdManagerDelegate {
    func didRenderAd(request: NimbusRequest, ad: NimbusAd, controller: AdController) {
        print("didRenderAd")
        adController = controller
        adController?.delegate = self
        nimbusAd = ad
    }
    
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

extension NimbusVungleRequestInterceptor {
    static var enabled: Bool {
        get {
            NimbusRequestManager.requestInterceptors?.contains(where: { $0 is NimbusVungleRequestInterceptor }) ?? false
        }
        set {
            if newValue, let interceptor = shared {
                NimbusRequestManager.requestInterceptors?.append(interceptor)
            } else if !newValue {
                NimbusRequestManager.requestInterceptors?.removeAll(where: { $0 is NimbusVungleRequestInterceptor })
            }
        }
    }
}
