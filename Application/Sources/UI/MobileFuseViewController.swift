//
//  MobileFuseViewController.swift
//  NimbusInternalSampleApp
//
//  Created on 9/15/23.
//  Copyright © 2023 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import NimbusKit

///  When integrating MobileFuse, consider examples like MobileFuseBannerViewController inherit from UIViewController.
///  Both SampleAdViewController and MobileFuseViewController just facilitate the needs of the sample app.
class MobileFuseViewController: SampleAdViewController {
    
    deinit {
        Task.detached { @MainActor in
            NimbusAdManager.removeMobileFuseHeader()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NimbusAdManager.insertMobileFuseHeader()
    }
}
