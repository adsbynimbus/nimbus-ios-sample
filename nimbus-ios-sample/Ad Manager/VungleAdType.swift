//
//  VungleAdType.swift
//  nimbus-ios-sample
//
//  Created by Victor Takai on 21/09/22.
//

import Foundation

enum VungleAdType: String, DemoItem {
    case vungleBanner
    case vungleMREC
    case vungleInterstitial
    case vungleRewarded
    case vungleNative
    
    var description: String {
        if self == .vungleMREC {
            return "Vungle MREC"
        } else {
            return rawValue.camelCaseToWords()
        }
    }
}
