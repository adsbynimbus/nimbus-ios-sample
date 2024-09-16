//
//  AdMob+Initialization.swift
//  NimbusInternalSampleApp
//  Created on 9/11/24
//  Copyright © 2024 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import NimbusKit
import GoogleMobileAds
#if canImport(NimbusSDK) // CocoaPods
import NimbusSDK
#else                    // Swift Package Manager
import NimbusAdMobKit
#endif

extension UIApplicationDelegate {
    func setupAdMobDemand() {
        Nimbus.shared.renderers[.forNetwork("admob")] = NimbusAdMobAdRenderer()
    }
}
