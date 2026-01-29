//
//  Meta+Initialization.swift
//  Nimbus
//  Created on 1/28/26
//  Copyright © 2026 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import FBAudienceNetwork

extension UIApplicationDelegate {
    func setupMetaDemand() {
        FBAdSettings.addTestDevice(FBAdSettings.testDeviceHash())
        
        // Required for test ads
        FBAdSettings.setAdvertiserTrackingEnabled(true)
    }
}
