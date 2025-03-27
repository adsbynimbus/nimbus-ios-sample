//
//  MobileFuse+Initialization.swift
//  NimbusInternalSampleApp
//
//  Created on 8/13/24.
//  Copyright © 2024 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import NimbusKit
#if canImport(NimbusSDK) // CocoaPods
import NimbusSDK
#else                    // Swift Package Manager
import NimbusMobileFuseKit
#endif

extension UIApplicationDelegate {
    /// It's important to initialize NimbusMobileFuseRequestInterceptor as soon as the app launches
    func setupMobileFuseDemand() {
        NimbusRequestManager.requestInterceptors?.append(NimbusMobileFuseRequestInterceptor())
        Nimbus.shared.renderers[.forNetwork("mobilefusesdk")] = NimbusMobileFuseAdRenderer()
        Nimbus.shared.controllers[.forNetwork("mobilefusesdk")] = NimbusMobileFuseAdController.self
    }
}
