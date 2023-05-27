//
//  Navigation.swift
//  nimbus-ios-sample
//
//  Created by Jason Sznol on 5/27/23.
//

import Foundation

protocol DemoItem: CaseIterable, CustomStringConvertible { }

extension RawRepresentable where RawValue == String, Self: DemoItem {
    var description: String {
        rawValue.camelCaseToWords()
    }
}

enum MainItem: String, DemoItem {
    case showAdDemo
    case mediationPlatforms
    case thirdPartyDemand
    case testRender
    case settings
}

enum AdManagerAdType: String, DemoItem {
    case manuallyRenderedAd
    case banner, bannerWithRefresh
    case inlineVideo
    case interstitialHybrid
    case interstitialStatic
    case interstitialVideo, interstitialVideoWithoutUI
    case rewardedVideo
    
    var description: String {
        switch self {
        case .interstitialVideoWithoutUI:
            return "Interstitial Video Without UI"
        default:
            return rawValue.camelCaseToWords()
        }
    }
}


enum MediationIntegrationType: String, DemoItem {
    case googleAdManager
    
    var description: String {
        rawValue.camelCaseToWords()
    }
}

enum MediationAdType: String, DemoItem {
    case banner, interstitial
    case dynamicPriceBanner, dynamicPriceBannerVideo, dynamicPriceInlineVideo, dynamicPriceInterstitial
    
    var description: String {
        switch self {
        case .dynamicPriceBannerVideo:
            return "Dynamic Price Banner + Video"
        default:
            return rawValue.camelCaseToWords()
        }
    }
}

enum ThirdPartyDemandIntegrationType: String, DemoItem {
    case aps
    case meta
    case unity
    case vungle
    
    var description: String {
        switch self {
        case .aps:
            return rawValue.uppercased()
        case .meta:
            return "Meta Audience Network"
        default:
            return rawValue.camelCaseToWords()
        }
    }
}


enum ThirdPartyDemandAdType: String, DemoItem {
    case apsBannerWithRefresh, apsInterstitialHybrid
    case metaBanner, metaInterstitial, metaNative
    case unityRewardedVideo
    case vungleBanner, vungleMREC, vungleInterstitial, vungleRewarded
    
    var description: String {
        switch self {
        case .apsBannerWithRefresh:
            return "APS Banner With Refresh"
        case .apsInterstitialHybrid:
            return "APS Interstitial Hybrid"
        case .vungleMREC:
            return "Vungle MREC"
        default:
            return rawValue.camelCaseToWords()
        }
    }
    
    public static var apsAdTypes = [apsBannerWithRefresh, apsInterstitialHybrid]
    public static var metaAdTypes = [metaBanner, metaInterstitial, metaNative]
    public static var unityAdTypes = [unityRewardedVideo]
    public static var vungleAdTypes = [vungleBanner, vungleMREC, vungleInterstitial, vungleRewarded]
}

enum Setting: String, DemoItem {
    case nimbusTestMode
    case coppaOn
    case forceNoFill
    case omThirdPartyViewability
    case tradeDesk
    
    case gdprConsent, ccpaConsent, gppConsent
    
    var description: String {
        switch self {
        case .coppaOn:
            return "Set COPPA On"
        case .omThirdPartyViewability:
            return "Send OMID Viewability Flag"
        case .tradeDesk:
            return "Send Trade Desk Identity"
        case .gdprConsent:
            return "GDPR Consent"
        case .ccpaConsent:
            return "CCPA Consent"
        case .gppConsent:
            return "GPP Consent"
        default:
            return rawValue.camelCaseToWords()
        }
    }
}
