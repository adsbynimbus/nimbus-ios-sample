//
//  FANViewController.swift
//  nimbus-ios-sample
//
//  Created by Victor Takai on 01/05/23.
//

import UIKit
import NimbusKit

#if canImport(NimbusLiveRampKit)
import NimbusLiveRampKit
#endif

#if canImport(NimbusRequestFANKit)
import NimbusRequestFANKit
#endif


final class FANViewController: DemoViewController {
    
    private let adType: ThirdPartyDemandAdType
    private var ad: NimbusAd?
    private var dimensions: NimbusAdDimensions?
    private var adContainerView: CustomAdContainerView?
    
    init(
        adType: ThirdPartyDemandAdType,
        headerTitle: String,
        headerSubTitle: String
    ) {
        self.adType = adType
        
        super.init(headerTitle: headerTitle, headerSubTitle: headerSubTitle)
       
        ad = createNimbusAd(adType: adType)
        dimensions = ad?.adDimensions
        
        guard let ad else { return }
        adContainerView = CustomAdContainerView(
            ad: ad,
            companionAd: nil,
            viewController: self,
            creativeScalingEnabledForStaticAds: true,
            delegate: self
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        setupRequestInterceptor()
        setupAdView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // If ad is interstitial, this controller will be the one presenting it,
        // so destroying the adView is required otherwise
        if let ad, !ad.isInterstitial {
            adContainerView?.destroy()
        }
        
        NimbusAdManager.requestInterceptors?.removeAll(where: {
            $0 is NimbusFANRequestInterceptor
        })
    }
    
    private func setupRequestInterceptor() {
        // Remove other demand providers. It MUST not remove LiveRampInterceptor
        NimbusAdManager.requestInterceptors?.removeAll(where: {
            !($0 is NimbusLiveRampInterceptor)
        })
        
        if let fan = DemoRequestInterceptors.shared.fan {
            NimbusAdManager.requestInterceptors?.append(fan)
        }
    }
    
    private func setupAdView() {
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
                adContainerView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor),
                adContainerView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor),
                adContainerView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor),
                adContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        }
    }
        
    private func createNimbusAd(adType: ThirdPartyDemandAdType) -> NimbusAd? {
        switch adType {
            
        case .facebookBanner:
            return createNimbusAd(
                network: "facebook",
                placementId: "IMG_16_9_LINK#\(ConfigManager.shared.fbBannerPlacementId!)",
                auctionType: .static,
                isInterstitial: false,
                adDimensions: NimbusAdDimensions(width: 300, height: 50)
            )
            
        case .facebookInterstitial:
            return createNimbusAd(
                network: "facebook",
                placementId: "IMG_16_9_LINK#\(ConfigManager.shared.fbInterstitialPlacementId!)",
                auctionType: .static,
                isInterstitial: true,
                adDimensions: nil
            )
            
        case .facebookNative:
            return createNimbusAd(
                network: "facebook",
                placementId: "IMG_16_9_LINK#\(ConfigManager.shared.fbNativePlacementId!)",
                auctionType: .native,
                isInterstitial: false,
                adDimensions: NimbusAdDimensions(width: 320, height: 480)
            )
            
        default:
            return nil
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
            network: network,
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
    }
    
    func didReceiveNimbusError(controller: AdController, error: NimbusError) {
        print("Nimbus didReceiveNimbusError: \(error)")
    }
}
