//
//  AdManagerAdType.swift
//  nimbus-ios-sample
//
//  Created by Victor Takai on 18/11/21.
//

import Foundation

enum AdManagerAdType: String, DemoItem {
    case swipeInterstitial
    case manualRequestRenderAd
    case banner
    case video
    case interstitialStatic
    case interstitialVideo, interstitialVideoWithUI
    case interstitialHybrid
    case rewardedStatic
    case rewardedVideo
    case rewardedVideoUnity
    
    var description: String {
        switch self {
        case .swipeInterstitial:
            return "Swipe Interstitial"
        case .manualRequestRenderAd:
            return "Manual Request/Render Ad"
        case .interstitialVideoWithUI:
            return "Interstitial Video With UI"
        case .rewardedStatic:
            return rawValue.camelCaseToWords() + " (5 sec)"
        case .rewardedVideo, .rewardedVideoUnity:
            return rawValue.camelCaseToWords()
        default:
            return rawValue.camelCaseToWords()
        }
    }
}
