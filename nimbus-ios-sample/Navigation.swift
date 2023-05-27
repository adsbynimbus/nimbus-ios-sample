//
//  Navigation.swift
//  nimbus-ios-sample
//
//  Created by Jason Sznol on 5/27/23.
//

import Foundation

protocol DemoItem: CaseIterable, CustomStringConvertible { }

extension RawRepresentable where RawValue == String, Self: DemoItem {
    var description: String { rawValue }
}

enum MainItem: String, DemoItem {
    case showAdDemo         = "Show Ad Demo"
    case mediationPlatforms = "Mediation Platforms"
    case thirdPartyDemand   = "Third Party Demand"
    case testRender         = "Test Render"
    case settings           = "Settings"
}

enum AdManagerAdType: String, DemoItem {
    case manuallyRenderedAd         = "Manually Rendered Ad"
    case banner                     = "Banner"
    case bannerWithRefresh          = "Banner With Refresh"
    case inlineVideo                = "Inline Video"
    case interstitialHybrid         = "Interstitial Hybrid"
    case interstitialStatic         = "Interstitial Static"
    case interstitialVideo          = "Interstitial Video"
    case interstitialVideoWithoutUI = "Interstitial Video Without UI"
    case rewardedVideo              = "Rewarded Video"
}


enum MediationIntegrationType: String, DemoItem {
    case googleAdManager = "Google Ad Manager"
}

enum MediationAdType: String, DemoItem {
    case banner                   = "Banner"
    case interstitial             = "Interstitial"
    case dynamicPriceBanner       = "Dynamic Price Banner"
    case dynamicPriceBannerVideo  = "Dynamic Price Banner + Video"
    case dynamicPriceInlineVideo  = "Dynamic Price Inline Video"
    case dynamicPriceInterstitial = "Dynamic Price Interstitial"
}

enum ThirdPartyDemandIntegrationType: String, DemoItem {
    case aps    = "APS"
    case meta   = "Meta Audience Network"
    case unity  = "Unity"
    case vungle = "Vungle"
}


enum ThirdPartyDemandAdType: String, DemoItem {
    case apsBannerWithRefresh   = "APS Banner With Refresh"
    case apsInterstitialHybrid  = "APS Interstitial Hybrid"
    case metaBanner             = "Meta Banner"
    case metaInterstitial       = "Meta Interstitial"
    case metaNative             = "Meta Native"
    case unityRewardedVideo     = "Unity Rewarded Video"
    case vungleBanner           = "Vungle Banner"
    case vungleMREC             = "Vungle MREC"
    case vungleInterstitial     = "Vungle Interstitial"
    case vungleRewarded         = "Vungle Rewarded"
        
    public static var apsAdTypes = [apsBannerWithRefresh, apsInterstitialHybrid]
    public static var metaAdTypes = [metaBanner, metaInterstitial, metaNative]
    public static var unityAdTypes = [unityRewardedVideo]
    public static var vungleAdTypes = [vungleBanner, vungleMREC, vungleInterstitial, vungleRewarded]
}

enum SettingsSection: String, DemoItem {
    case main
    case userDetails = "User Details"
}

enum Setting: String, DemoItem {
    case nimbusTestMode          = "Nimbus Test Mode"
    case coppaOn                 = "Set COPPA On"
    case forceNoFill             = "Force No Fill"
    case omThirdPartyViewability = "Send OMID Viewability Flag"
    case tradeDesk               = "Send Trade Desk Identity"
    case gdprConsent             = "GDPR Consent"
    case ccpaConsent             = "CCPA Consent"
    case gppConsent              = "GPP Consent"
}
