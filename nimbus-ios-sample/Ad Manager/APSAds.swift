//
//  APSAds.swift
//  NimbusInternalSampleApp
//
//  Created by Inder Dhir on 3/23/23.
//  Copyright © 2023 Timehop. All rights reserved.
//

import DTBiOSSDK

var apsAdSizes: [DTBAdSize] {
    [
        .init(interstitialAdSizeWithSlotUUID: "4e918ac0-5c68-4fe1-8d26-4e76e8f74831"),
        .init(bannerAdSizeWithWidth: 320, height: 50, andSlotUUID: "5ab6a4ae-4aa5-43f4-9da4-e30755f2b295"),
        .init(videoAdSizeWithSlotUUID: "4acc26e6-3ada-4ee8-bae0-753c1e0ad278")
    ]
}
