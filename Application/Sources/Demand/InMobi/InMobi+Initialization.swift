//
//  InMobi+Initialization.swift
//  Nimbus
//  Created on 7/31/25
//  Copyright © 2025 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import NimbusKit
import InMobiSDK
#if canImport(NimbusSDK) // CocoaPods
import NimbusSDK
#else                    // Swift Package Manager
import NimbusInMobiKit
#endif

fileprivate var inmobiAccountId = Bundle.main.infoDictionary?["InMobi Account ID"] as! String

extension UIApplicationDelegate {
    func setupInMobiDemand() {
        /// It's important to call initialize as soon as the app launches.
        /// Make sure to call IMSdk.init from the main thread
        IMSdk.initWithAccountID(inmobiAccountId) { error in
            if let error {
                print("InMobi initialization failed with error: \(error)")
            }
        }
    }
}
