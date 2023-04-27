//
//  ApsAdType.swift
//  nimbus-ios-sample
//
//  Created by Bruno Bruggemann on 20/04/23.
//

enum ThirdPartyDemandAdType: String, DemoItem {
    case apsRefreshingBanner, apsInterstitialHybrid
    case facebookBanner, facebookInterstitial, facebookNative
    case rewardedVideoUnity
    
    var description: String {
        switch self {
        case .apsRefreshingBanner:
            return "APS Refreshing Banner (30 sec)"
        case .apsInterstitialHybrid:
            return "APS Interstitial Hybrid"
        default:
            return rawValue.camelCaseToWords()
        }
    }
    
    public static var apsAdType = [apsRefreshingBanner, apsInterstitialHybrid]
    public static var fanAdType = [facebookBanner, facebookInterstitial, facebookNative]
    public static var unityAdType = [rewardedVideoUnity]
}
