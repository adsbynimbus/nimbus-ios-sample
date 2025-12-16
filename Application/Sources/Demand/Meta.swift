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
    var response: NimbusResponse?
    private var ad: Ad?
    
    init(adType: MetaSample, headerSubTitle: String) {
        self.adType = adType
        
        super.init(headerTitle: adType.description, headerSubTitle: headerSubTitle, enabledExtension: MetaExtension.self)
       
        response = createNimbusAd(adType: adType)
        dimensions = response?.bid.adDimensions
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
            Task { try await setupAdView() }
        }
    }
    
    private func setupAdView() async throws {
        guard let response else { return }
        
        switch adType {
        case .metaBanner, .metaNative:
            ad = try await Nimbus.inlineAd(from: response).show(in: view)
        case .metaInterstitial:
            ad = try await Nimbus.interstitialAd(from: response).show(in: self)
        case .metaRewardedVideo:
            ad = try await Nimbus.rewardedAd(from: response).show(in: self)
        }
    }

    private func createNimbusAd(adType: MetaSample) -> NimbusResponse {
        switch adType {

        case .metaBanner:
            return createNimbusAd(
                placementId: "IMG_16_9_LINK#\(metaBannerId)",
                markupType: .banner,
                isInterstitial: false,
                adDimensions: NimbusAdDimensions(width: 320, height: 50)
            )
            
        case .metaInterstitial:
            return createNimbusAd(
                placementId: "IMG_16_9_LINK#\(metaInterstitialId)",
                markupType: .banner,
                isInterstitial: true,
                adDimensions: NimbusAdDimensions(width: 320, height: 480)
            )
            
        case .metaNative:
            return createNimbusAd(
                placementId: "IMG_16_9_LINK#\(metaNativeId)",
                markupType: .native,
                isInterstitial: false,
                adDimensions: UIDevice.nimbusIsLandscape ? NimbusAdDimensions.landscapeInlineAd : NimbusAdDimensions.portraitInlineAd
            )
        case .metaRewardedVideo:
            return createNimbusAd(
                placementId: "VID_HD_16_9_15S_LINK#\(metaRewardedVideoId)",
                markupType: .video,
                isInterstitial: true,
                adDimensions: NimbusAdDimensions(width: 320, height: 480)
            )
        }
    }
    
    private func createNimbusAd(
        network: String = "",
        placementId: String? = nil,
        markupType: NimbusResponse.Bid.MarkupType,
        markup: String = "",
        isMraid: Bool = true,
        isInterstitial: Bool,
        adDimensions: NimbusAdDimensions? = nil
    ) -> NimbusResponse {
        return NimbusResponse(
            id: nil,
            bid: .init(
                mtype: markupType,
                adm: markup,
                price: 0,
                adomain: nil,
                bundle: nil,
                w: adDimensions?.width,
                h: adDimensions?.height,
                cid: nil,
                crid: nil,
                cat: nil,
                attr: nil,
                dealid: nil,
                exp: nil,
                ext: nil))
    }
    
    func didReceiveNimbusEvent(controller: AdController, event: NimbusEvent) {
        super.didReceiveNimbusEvent(event: event)
    }
    
    func didReceiveNimbusError(controller: AdController, error: any NimbusError) {
        super.didReceiveNimbusError(error: error)
    }
}
