//
//  Constants.swift
//  AdMobUIKitSample
//  Created on 9/19/24
//  Copyright © 2024 Nimbus Advertising Solutions Inc. All rights reserved.
//

import Foundation

let adMobAppId = Bundle.main.infoDictionary?["GADApplicationIdentifier"] as? String ?? ""
let bannerAdUnitId = Bundle.main.infoDictionary?["AdMob Banner ID"] as? String ?? ""
let nativeAdUnitId = Bundle.main.infoDictionary?["AdMob Native ID"] as? String ?? ""
let interstitialAdUnitId = Bundle.main.infoDictionary?["AdMob Interstitial ID"] as? String ?? ""
let rewardedAdUnitId = Bundle.main.infoDictionary?["AdMob Rewarded ID"] as? String ?? ""
