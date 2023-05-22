//
//  MediationAdType.swift
//  nimbus-ios-sample
//
//  Created by Victor Takai on 18/11/21.
//

import Foundation

enum MediationAdType: String, DemoItem {
    case banner, interstitial
    case dynamicPriceBanner, dynamicPriceBannerVideo, dynamicPriceInterstitial
    
    var description: String {
        switch self {
        case .dynamicPriceBannerVideo:
            return "Dynamic Price Banner + Video"
        default:
            return rawValue.camelCaseToWords()
        }
    }
}
