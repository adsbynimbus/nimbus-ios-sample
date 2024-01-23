//
//  GAMBaseViewController.swift
//  NimbusInternalSampleApp
//  Created on 1/23/24
//  Copyright © 2024 Nimbus Advertising Solutions Inc. All rights reserved.
//
//

import UIKit
import NimbusKit
#if canImport(NimbusGAMKit)                    // Swift Package Manager
import NimbusGAMKit
#elseif canImport(NimbusSDK)                   // CocoaPods
import NimbusSDK
#endif

let googleDynamicPricePlacementId = Bundle.main.infoDictionary?["Google Nimbus Rendering Placement ID"] as? String ?? ""
let googleDynamicPriceRewardedPlacementId = Bundle.main.infoDictionary?["Google Nimbus Rendering Rewarded Placement ID"] as? String ?? ""

class GAMBaseViewController: DemoViewController {
    private var requestInterceptors: [NimbusRequestInterceptor]?
    
    // Sample Price Mapping configured for testing only.
    // Contact your Nimbus account manager for the values setup with your account.
    let mapping = NimbusGAMLinearPriceMapping(granularities: [
         NimbusGAMLinearPriceGranularity(min: 0, max: 0, step: 1),
    ])
    
    deinit {
        NimbusAdManager.requestInterceptors = requestInterceptors
    }
    
    // Please ignore this interceptor logic when integrating Dynamic Price.
    // The sample app sets multiple interceptors as it showcases a wide
    // range of ads and integrations, so this code merely makes sure no
    // interceptors are active.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestInterceptors = NimbusAdManager.requestInterceptors
        NimbusAdManager.requestInterceptors = nil
    }
}
