//
//  ApsAdType.swift
//  nimbus-ios-sample
//
//  Created by Bruno Bruggemann on 20/04/23.
//

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
