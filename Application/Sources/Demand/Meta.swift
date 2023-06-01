//
//  FANViewController.swift
//  nimbus-ios-sample
//
//  Created by Victor Takai on 01/05/23.
//

import FBAudienceNetwork
import NimbusKit
#if canImport(NimbusSDK) // CocoaPods
import NimbusSDK
#else                    // Swift Package Manager
import NimbusRenderFANKit
import NimbusRequestFANKit
#endif
import UIKit

let metaBannerId = Bundle.main.infoDictionary?["Meta Banner Placement ID"] as? String ?? ""
let metaInterstitialId = Bundle.main.infoDictionary?["Meta Interstitial Placement ID"] as? String ?? ""
let metaNativeId = Bundle.main.infoDictionary?["Meta Native Placement ID"] as? String ?? ""
let metaAppId = metaNativeId.components(separatedBy: "_").first

extension UIApplicationDelegate {
    func setupMetaDemand() {
        if let metaAppId = metaAppId {
            NimbusRequestManager.requestInterceptors?.append(NimbusFANRequestInterceptor(appId: metaAppId))
            Nimbus.shared.renderers[.forNetwork("facebook")] = NimbusFANAdRenderer()
            
            FBAdSettings.addTestDevice(FBAdSettings.testDeviceHash())
            // Required for test ads
            FBAdSettings.setAdvertiserTrackingEnabled(true)
        }
    }
}

final class FANViewController: DemoViewController {
    
    private let adType: MetaSample
    private var ad: NimbusAd?
    private var dimensions: NimbusAdDimensions?
    private var adContainerView: CustomAdContainerView?
    
    init(adType: MetaSample, headerSubTitle: String) {
        self.adType = adType
        
        super.init(headerTitle: adType.description, headerSubTitle: headerSubTitle)
       
        ad = createNimbusAd(adType: adType)
        dimensions = ad?.adDimensions
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        if adType == .metaBanner && metaBannerId.isEmpty {
            showCustomAlert("facebook_banner_placement_id")
        } else if adType == .metaInterstitial && metaInterstitialId.isEmpty {
            showCustomAlert("facebook_interstitial_placement_id")
        } else if adType == .metaNative && metaNativeId.isEmpty {
            showCustomAlert("facebook_native_placement_id")
        } else {
            setupAdView()
        }
    }
    
    deinit {
        adContainerView?.destroy()
    }
    
    private func setupAdView() {
        guard let ad else { return }
        
        adContainerView = CustomAdContainerView(
            ad: ad,
            companionAd: nil,
            viewController: self,
            creativeScalingEnabledForStaticAds: true,
            delegate: self
        )
        
        guard let adContainerView else { return }
        
        view.addSubview(adContainerView)
        
        adContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        if let dimensions {
            NSLayoutConstraint.activate([
                adContainerView.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
                adContainerView.safeAreaLayoutGuide.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
                adContainerView.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: CGFloat(dimensions.width)),
                adContainerView.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: CGFloat(dimensions.height)),
            ])
        } else {
            NSLayoutConstraint.activate([
                adContainerView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
                adContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                adContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                adContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ])
        }
    }
        
    private func createNimbusAd(adType: MetaSample) -> NimbusAd {
        switch adType {
            
        case .metaBanner:
            return createNimbusAd(
                placementId: "IMG_16_9_LINK#\(metaBannerId)",
                auctionType: .static,
                isInterstitial: false,
                adDimensions: NimbusAdDimensions(width: 320, height: 50)
            )
            
        case .metaInterstitial:
            return createNimbusAd(
                placementId: "IMG_16_9_LINK#\(metaInterstitialId)",
                auctionType: .static,
                isInterstitial: true,
                adDimensions: NimbusAdDimensions(width: 320, height: 480)
            )
            
        case .metaNative:
            return createNimbusAd(
                placementId: "IMG_16_9_LINK#\(metaNativeId)",
                auctionType: .native,
                isInterstitial: false,
                adDimensions: NimbusAdDimensions(width: 320, height: 480)
            )
        }
    }
    
    private func createNimbusAd(
        network: String = "",
        placementId: String? = nil,
        auctionType: NimbusAuctionType,
        markup: String = "",
        isMraid: Bool = true,
        isInterstitial: Bool,
        adDimensions: NimbusAdDimensions? = nil
    ) -> NimbusAd {
        NimbusAd(
            position: "",
            auctionType: auctionType,
            bidRaw: 0,
            bidInCents: 0,
            contentType: "",
            auctionId: "",
            network: "facebook",
            markup: markup,
            isInterstitial: isInterstitial,
            placementId: placementId ?? "",
            duration: nil,
            adDimensions: adDimensions,
            trackers: nil,
            isMraid: isMraid,
            extensions: nil
        )
    }
}

extension FANViewController: AdControllerDelegate {
    
    func didReceiveNimbusEvent(controller: AdController, event: NimbusEvent) {
        print("Nimbus didReceiveNimbusEvent: \(event)")
        if let ad = ad, event == .loaded {
            controller.adView?.setUiTestIdentifiers(for: ad)
        }
    }
    
    func didReceiveNimbusError(controller: AdController, error: NimbusError) {
        print("Nimbus didReceiveNimbusError: \(error)")
    }
}
