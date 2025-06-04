//
//  MobileFuseViewController.swift
//  NimbusInternalSampleApp
//
//  Created on 9/15/23.
//  Copyright © 2023 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import NimbusKit

#if canImport(NimbusSDK) // CocoaPods
import NimbusSDK
#elseif canImport(NimbusMobileFuseKit) // Swift Package Manager
import NimbusMobileFuseKit
#endif

///  When integrating MobileFuse, consider examples like MobileFuseBannerViewController inherit from UIViewController.
///  Both SampleAdViewController and MobileFuseViewController just facilitate the needs of the sample app.
class MobileFuseViewController: SampleAdViewController {
    
    deinit {
        Task { @MainActor in NimbusAdManager.removeMobileFuseHeader() }
    }
    
    init(headerTitle: String, headerSubTitle: String) {
        super.init(headerTitle: headerTitle, headerSubTitle: headerSubTitle, enabledExtension: MobileFuseExtension.self)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NimbusAdManager.insertMobileFuseHeader()
    }
}
