//
//  FANViewController.swift
//  nimbus-ios-sample
//
//  Created on 01/05/23.
//

import FBAudienceNetwork
import NimbusKit
#if canImport(NimbusSDK) // CocoaPods
import NimbusSDK
#else                    // Swift Package Manager
import NimbusMetaKit
#endif
import UIKit

let metaBannerId = Bundle.main.infoDictionary?["Meta Banner Placement ID"] as? String ?? ""
let metaInterstitialId = Bundle.main.infoDictionary?["Meta Interstitial Placement ID"] as? String ?? ""
let metaNativeId = Bundle.main.infoDictionary?["Meta Native Placement ID"] as? String ?? ""
let metaRewardedVideoId = Bundle.main.infoDictionary?["Meta Rewarded Video Placement ID"] as? String ?? ""

extension UIApplicationDelegate {
    func setupMetaDemand() {
        FBAdSettings.addTestDevice(FBAdSettings.testDeviceHash())
        // Required for test ads
        FBAdSettings.setAdvertiserTrackingEnabled(true)
    }
}

final class FANViewController: SampleAdViewController, AdControllerDelegate {
    
    private let adType: MetaSample
    private var dimensions: NimbusAdDimensions?
    private var adController: AdController?
    var nimbusAd: NimbusAd?
    
    init(adType: MetaSample, headerSubTitle: String) {
        self.adType = adType
        
        super.init(headerTitle: adType.description, headerSubTitle: headerSubTitle, enabledExtension: MetaExtension.self)
       
        nimbusAd = createNimbusAd(adType: adType)
        dimensions = nimbusAd?.adDimensions
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if adType == .metaBanner && metaBannerId.isEmpty {
            showCustomAlert("META_BANNER_PLACEMENT_ID")
        } else if adType == .metaInterstitial && metaInterstitialId.isEmpty {
            showCustomAlert("META_INTERSTITIAL_PLACEMENT_ID")
        } else if adType == .metaNative && metaNativeId.isEmpty {
            showCustomAlert("META_NATIVE_PLACEMENT_ID")
        } else if adType == .metaRewardedVideo && metaRewardedVideoId.isEmpty {
            showCustomAlert("META_REWARDED_VIDEO_PLACEMENT_ID")
        } else {
            setupAdView()
        }
    }
    
    private func setupAdView() {
        guard let nimbusAd else { return }
        
        switch adType {
        case .metaBanner, .metaNative:
            adController = try! Nimbus.load(ad: nimbusAd, container: view, adPresentingViewController: self, delegate: self)
        case .metaInterstitial, .metaRewardedVideo:
            adController = try! Nimbus.loadBlocking(
                ad: nimbusAd,
                presentingViewController: self,
                delegate: self,
                isRewarded: adType == .metaRewardedVideo
            )
            adController?.start()
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
                adDimensions: UIDevice.nimbusIsLandscape ? NimbusAdDimensions.landscapeInlineAd : NimbusAdDimensions.portraitInlineAd
            )
        case .metaRewardedVideo:
            return createNimbusAd(
                placementId: "VID_HD_16_9_15S_LINK#\(metaRewardedVideoId)",
                auctionType: .video,
                isInterstitial: true,
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
    
    func didReceiveNimbusEvent(controller: any AdController, event: NimbusEvent) {
        super.didReceiveNimbusEvent(event: event)
    }
    
    func didReceiveNimbusError(controller: any AdController, error: any NimbusError) {
        super.didReceiveNimbusError(error: error)
    }
}
