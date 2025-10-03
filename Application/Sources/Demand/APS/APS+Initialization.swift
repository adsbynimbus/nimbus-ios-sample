//
//  APS+Initialization.swift
//  Nimbus
//  Created on 9/5/25
//  Copyright © 2025 Nimbus Advertising Solutions Inc. All rights reserved.
//

import DTBiOSSDK
import NimbusKit
import UIKit

fileprivate let apsAppKey = Bundle.main.infoDictionary?["APS App ID"] as? String

extension UIApplicationDelegate {
    func setupAmazonDemand() {
        if let appKey = apsAppKey {
            DTBAds.sharedInstance().setAppKey(appKey)
            DTBAds.sharedInstance().mraidPolicy = CUSTOM_MRAID
            DTBAds.sharedInstance().mraidCustomVersions = ["1.0", "2.0", "3.0"]
            DTBAds.sharedInstance().testMode = Nimbus.shared.testMode
            #if DEBUG
            DTBAds.sharedInstance().setLogLevel(DTBLogLevelDebug)
            #endif
        }
    }
}
