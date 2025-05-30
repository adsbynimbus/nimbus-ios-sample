//
//  Moloco+Initialization.swift
//  Nimbus
//  Created on 5/28/25
//  Copyright © 2025 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import NimbusKit
import MolocoSDK
#if canImport(NimbusSDK) // CocoaPods
import NimbusSDK
#else                    // Swift Package Manager
import NimbusMolocoKit
#endif

fileprivate var molocoAppKey = Bundle.main.infoDictionary?["Moloco App Key"] as! String

extension UIApplicationDelegate {
    func setupMolocoDemand() {
        /// It's important to call initialize as soon as the app launches
        MolocoSDK.Moloco.shared.initialize(initParams: .init(appKey: molocoAppKey)) { done, error in
            if let error {
                print("Moloco initialization failed: \(error)")
            } else {
                print("Moloco initialization was successful")
            }
        }
        Nimbus.shared.renderers[.moloco] = NimbusMolocoAdRenderer()
    }
}
