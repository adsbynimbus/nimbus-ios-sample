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
import VungleAdsSDK

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

class VungleViewController: SampleAdViewController {
    
    private let contentView = UIView()
    
    private let adType: VungleSample
    private var adManager: NimbusAdManager?
    private var adController: AdController?
    
    init(adType: VungleSample, headerSubTitle: String) {
        self.adType = adType
        
        super.init(headerTitle: adType.description, headerSubTitle: headerSubTitle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let renderer = NimbusVungleAdRenderer()
//        renderer.adRendererDelegate = self
//        
//        Nimbus.shared.renderers[.forNetwork("vungle")] = renderer
        
        // Enable Vungle Demand for this screen only
//        NimbusVungleRequestInterceptor.enabled = true
//        NimbusRequestManager.requestInterceptors?.append(self)
        
        NimbusAdManager.requestInterceptors = nil
        
        NimbusRequestManager.requestInterceptors = [
            NimbusVungleRequestInterceptor(appId: vungleAppId!)
        ]
        
        
        
        setupContentView()
        setupAdRendering()
    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        NimbusVungleRequestInterceptor.enabled = false
//        NimbusRequestManager.requestInterceptors?.removeAll { $0 === self }
//    }
    
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
        case .vungleNative:
//            let dimensions = NimbusAdDimensions(width: 300, height: 250)
//            let ad = NimbusAd(
//                position: "",
//                auctionType: .native,
//                bidRaw: 0,
//                bidInCents: 0,
//                contentType: "",
//                auctionId: "",
//                network: "vungle",
//                markup: "",
//                isInterstitial: false,
//                placementId: "NIMBUS_IOS_NATIVE-7709644",
//                duration: nil,
//                adDimensions: dimensions,
//                trackers: nil,
//                isMraid: false,
//                extensions: nil
//            )
//            
//            let adContainerView = CustomAdContainerView(
//                ad: ad,
//                companionAd: nil,
//                viewController: self,
//                creativeScalingEnabledForStaticAds: false,
//                delegate: self
//            )
//            
//            view.addSubview(adContainerView)
//            
//            NSLayoutConstraint.activate([
//                adContainerView.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
//                adContainerView.safeAreaLayoutGuide.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
//                adContainerView.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: CGFloat(dimensions.width)),
//                adContainerView.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: CGFloat(dimensions.height)),
//            ])
            
            adManager?.showAd(
                request: NimbusRequest.forNativeBannerAd(position: "NIMBUS_IOS_NATIVE-7709644", format: .letterbox),
                container: contentView,
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

//extension VungleViewController: NimbusVungleAdRendererDelegate {
//    func customViewForRendering(container: UIView, nativeAd: VungleNative) -> NimbusVungleNativeAdViewType {
//        return NimbusVungleNative
//    }
//}

extension VungleViewController: NimbusRequestInterceptor {
    
    func modifyRequest(request: NimbusRequestKit.NimbusRequest) {
        request.user?.extensions?.removeValue(forKey: "unity_buyeruid")
        request.user?.extensions?.removeValue(forKey: "facebook_buyeruid")
        request.impressions[0].extensions?.removeValue(forKey: "facebook_app_id")
    }
    
    func didCompleteNimbusRequest(with ad: NimbusAd) { }
    func didFailNimbusRequest(with error: NimbusError) { }
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
