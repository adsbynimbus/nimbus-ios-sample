//
//  AdManagerSpecificAdType.swift
//  NimbusInternalSampleApp
//
//  Created by Inder Dhir on 6/10/22.
//  Copyright © 2022 Timehop. All rights reserved.
//

import Foundation

enum AdManagerSpecificAdType: String, DemoItem  {
    case refreshingBanner, adsInScrollList
    
    var description: String {
        switch self {
        case .refreshingBanner:
            return "Refreshing Banner (30 sec)"
        case .adsInScrollList:
            return "Ads In Scroll List"
        }
    }
}
