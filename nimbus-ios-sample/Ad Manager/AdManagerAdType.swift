//
//  AdManagerAdType.swift
//  nimbus-ios-sample
//
//  Created by Victor Takai on 18/11/21.
//

import Foundation

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
