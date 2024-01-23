//
//  GAMBaseViewController.swift
//  NimbusInternalSampleApp
//  Created on 1/23/24
//  Copyright © 2024 Nimbus Advertising Solutions Inc. All rights reserved.
//
//  Please ignore this controller when integrating dynamic price with Nimbus.
//  This controller merely makes sure there are no active request interceptors
//  for these use cases. This sample app sets multiple interceptors as it showcases a wide
//  range of ads and integrations.
//

import UIKit
import NimbusKit
#if canImport(NimbusGAMKit)                    // Swift Package Manager
import NimbusGAMKit
#elseif canImport(NimbusSDK)                   // CocoaPods
import NimbusSDK
#endif

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestInterceptors = NimbusAdManager.requestInterceptors
        NimbusAdManager.requestInterceptors = nil
    }
}
