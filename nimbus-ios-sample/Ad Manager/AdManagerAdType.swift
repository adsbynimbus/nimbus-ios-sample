//
//  AdManagerAdType.swift
//  nimbus-ios-sample
//
//  Created by Victor Takai on 18/11/21.
//

import Foundation

enum AdManagerAdType: String, DemoItem {
    case manualRequestRenderAd
    case banner
    case video
    case interstitialStatic
    case interstitialVideo
    case interstitialHybrid
    case blockingInterstitial
    case rewardedStatic
    case rewardedVideo
    case rewardedVideoUnity
    
    var description: String {
        switch self {
        case .manualRequestRenderAd:
            return "Manual Request/Render Ad"
        case .blockingInterstitial, .rewardedStatic, .rewardedVideo, .rewardedVideoUnity:
            return rawValue.camelCaseToWords() + " (5 sec)"
        default:
            return rawValue.camelCaseToWords()
        }
    }
}
