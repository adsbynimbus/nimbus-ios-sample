//
//  AdMobViewController.swift
//  NimbusInternalSampleApp
//  Created on 9/11/24
//  Copyright © 2024 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import NimbusKit

///  When integrating AdMob, consider examples like AdMobBannerViewController inherit from UIViewController.
///  Both SampleAdViewController and AdMobViewController just facilitate the needs of the sample app.
class AdMobViewController: SampleAdViewController {
    weak var sweepingInterceptor: SweepingInterceptor?
    
    deinit {
        NimbusAdManager.requestInterceptors?.removeAll(where: { $0 === sweepingInterceptor })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sweepingInterceptor = SweepingInterceptor(keep: .admob)
        NimbusAdManager.requestInterceptors?.append(sweepingInterceptor)
        self.sweepingInterceptor = sweepingInterceptor
    }
}
