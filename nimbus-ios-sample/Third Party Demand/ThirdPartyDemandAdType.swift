//
//  ApsAdType.swift
//  nimbus-ios-sample
//
//  Created by Bruno Bruggemann on 20/04/23.
//

enum ThirdPartyDemandAdType: String, DemoItem {
    case apsRefreshingBanner, apsInterstitialHybrid
    case facebookBanner, facebookInterstitial, facebookNative
    case unityRewardedVideo
    case vungleBanner, vungleMREC, vungleInterstitial, vungleRewarded
    
    var description: String {
        switch self {
        case .apsRefreshingBanner:
            return "APS Refreshing Banner (30 sec)"
        case .apsInterstitialHybrid:
            return "APS Interstitial Hybrid"
        case .vungleMREC:
            return "Vungle MREC"
        default:
            return rawValue.camelCaseToWords()
        }
    }
    
    public static var apsAdTypes = [apsRefreshingBanner, apsInterstitialHybrid]
    public static var fanAdTypes = [facebookBanner, facebookInterstitial, facebookNative]
    public static var unityAdTypes = [unityRewardedVideo]
    public static var vungleAdTypes = [vungleBanner, vungleMREC, vungleInterstitial, vungleRewarded]
}
