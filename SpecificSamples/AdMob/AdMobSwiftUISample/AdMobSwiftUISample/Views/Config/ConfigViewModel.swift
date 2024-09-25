//
//  ConfigViewModel.swift
//  AdMobSwiftUISample
//  Created on 9/19/24
//  Copyright © 2024 Nimbus Advertising Solutions Inc. All rights reserved.
//

import SwiftUI

struct ConfigItem: Identifiable {
    let name: String
    let isValid: Bool
    var id: String { name }
}

@MainActor
final class ConfigViewModel {
    lazy var items = [
        ConfigItem(name: "App Id", isValid: isAppIdValid),
        ConfigItem(name: "Banner Ad Unit Id", isValid: isAdUnitValid(bannerAdUnitId)),
        ConfigItem(name: "Native Ad Unit Id", isValid: isAdUnitValid(nativeAdUnitId)),
        ConfigItem(name: "Interstitial Ad Unit Id", isValid: isAdUnitValid(interstitialAdUnitId)),
        ConfigItem(name: "Rewarded Ad Unit Id", isValid: isAdUnitValid(rewardedAdUnitId)),
    ]
    
    var isAppIdValid: Bool {
        adMobAppId != "ca-app-pub-3940256099942544~1458002511"
    }
    
    func isAdUnitValid(_ adUnit: String) -> Bool {
        adUnit.first != "<" && adUnit.last != ">" && !adUnit.isEmpty
    }
}
