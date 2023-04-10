//
//  AdManagerSpecificAdType.swift
//  NimbusInternalSampleApp
//
//  Created by Inder Dhir on 6/10/22.
//  Copyright © 2022 Timehop. All rights reserved.
//

import Foundation

enum AdManagerSpecificAdType: String, DemoItem  {
    case refreshingBanner, apsRefreshingBanner, apsInterstitialHybrid
    
    var description: String {
        switch self {
        case .refreshingBanner:
            return "Refreshing Banner (30 sec)"
        case .apsRefreshingBanner:
            return "APS Refreshing Banner (30 sec)"
        case .apsInterstitialHybrid:
            return "APS Interstitial Hybrid"
        }
    }
}
