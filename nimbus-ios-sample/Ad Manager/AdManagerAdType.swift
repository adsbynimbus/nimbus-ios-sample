//
//  AdManagerAdType.swift
//  nimbus-ios-sample
//
//  Created by Victor Takai on 18/11/21.
//

import Foundation

enum AdManagerAdType: String, DemoItem {
    case manualRequestRenderAd
    case banner, refreshingBanner
    case video
    case interstitialStatic
    case interstitialVideo, interstitialVideoWithUI
    case interstitialHybrid
    case rewardedStatic
    case rewardedVideo
    
    var description: String {
        switch self {
        case .manualRequestRenderAd:
            return "Manual Request/Render Ad"
        case .refreshingBanner:
            return "Refreshing Banner (30 sec)"
        case .interstitialVideoWithUI:
            return "Interstitial Video With UI"
        case .rewardedStatic:
            return rawValue.camelCaseToWords() + " (5 sec)"
        default:
            return rawValue.camelCaseToWords()
        }
    }
}
