//
//  MobileFuseViewController.swift
//  NimbusInternalSampleApp
//
//  Created on 9/15/23.
//  Copyright © 2023 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import NimbusKit
import NimbusMobileFuseKit

extension UIApplicationDelegate {
    func setupMobileFuseDemand() {
        /// It's important to initialize NimbusMobileFuseRequestInterceptor as soon as the app launches
        NimbusRequestManager.requestInterceptors?.append(NimbusMobileFuseRequestInterceptor())
        Nimbus.shared.renderers[.forNetwork("mobilefusesdk")] = NimbusMobileFuseAdRenderer()
    }
}

class MobileFuseViewController: SampleAdViewController {
    
    deinit {
        NimbusAdManager.removeMobileFuseHeader()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NimbusAdManager.insertMobileFuseHeader()
    }
}
