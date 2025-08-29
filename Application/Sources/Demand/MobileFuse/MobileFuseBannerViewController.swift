//
//  MobileFuseBannerViewController.swift
//  NimbusInternalSampleApp
//
//  Created on 9/15/23.
//  Copyright © 2023 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import NimbusKit
import NimbusCoreKit
#if canImport(NimbusSDK) // CocoaPods
import NimbusSDK
#elseif canImport(NimbusMobileFuseKit) // Swift Package Manager
import NimbusMobileFuseKit
#endif

final class MobileFuseBannerViewController: MobileFuseViewController {
    
    private var bannerAd: InlineAd?
    private let position: String
    private let size: AdSize
    
    init(headerTitle: String, position: String, size: AdSize) {
        self.position = position
        self.size = size
        
        super.init(headerTitle: headerTitle, headerSubTitle: "")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            self.bannerAd = try await Nimbus.bannerAd(position: position, size: size, refreshInterval: 30).show(in: view)
        }
    }
}
