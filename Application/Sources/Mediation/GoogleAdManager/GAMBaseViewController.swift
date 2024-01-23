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

class GAMBaseViewController: DemoViewController {
    private var requestInterceptors: [NimbusRequestInterceptor]?
    
    deinit {
        NimbusAdManager.requestInterceptors = requestInterceptors
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestInterceptors = NimbusAdManager.requestInterceptors
        NimbusAdManager.requestInterceptors = nil
    }
}
