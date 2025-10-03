//
//  GAMBaseViewController.swift
//  NimbusInternalSampleApp
//  Created on 1/23/24
//  Copyright © 2024 Nimbus Advertising Solutions Inc. All rights reserved.
//
//

import UIKit
import Nimbus
#if canImport(NimbusGAMKit)                    // Swift Package Manager
import NimbusGAMKit
#elseif canImport(NimbusSDK)                   // CocoaPods
import NimbusSDK
#endif

let googleDynamicPricePlacementId = Bundle.main.infoDictionary?["Google Nimbus Rendering Placement ID"] as? String ?? ""
let googleDynamicPriceRewardedPlacementId = Bundle.main.infoDictionary?["Google Nimbus Rendering Rewarded Placement ID"] as? String ?? ""

class GAMBaseViewController: SampleAdViewController {
    // Sample Price Mapping configured for testing only.
    // Contact your Nimbus account manager for the values setup with your account.
    let mapping = NimbusGAMLinearPriceMapping(granularities: [
         NimbusGAMLinearPriceGranularity(min: 0, max: 0, step: 1),
    ])
    
    init(headerTitle: String, headerSubTitle: String) {
        super.init(headerTitle: headerTitle, headerSubTitle: headerSubTitle, enabledExtension: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
