//
//  Mintegral+Initialization.swift
//  Nimbus
//  Created on 10/30/24
//  Copyright © 2024 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import NimbusKit
import MTGSDK
#if canImport(NimbusSDK) // CocoaPods
import NimbusSDK
#else                    // Swift Package Manager
import NimbusMintegralKit
#endif

fileprivate var mintegralAppId = Bundle.main.infoDictionary?["Mintegral App ID"] as! String
fileprivate var mintegralAppKey = Bundle.main.infoDictionary?["Mintegral App Key"] as! String

extension UIApplicationDelegate {
    func setupMintegralDemand() {
        /// It's important to call initialize as soon as the app launches
        MTGSDK.sharedInstance().setAppID(mintegralAppId, apiKey: mintegralAppKey)
        Nimbus.shared.renderers[.forNetwork(.mintegral)] = NimbusMintegralAdRenderer()
    }
}
