//
//  AdMobViewController.swift
//  NimbusInternalSampleApp
//  Created on 9/11/24
//  Copyright © 2024 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import NimbusKit

import NimbusAdMobKit

///  When integrating AdMob, consider examples like AdMobBannerViewController inherit from UIViewController.
///  Both DemandViewController and AdMobViewController just facilitate the needs of the sample app.
class AdMobViewController: SampleAdViewController {
    convenience init(headerTitle: String, headerSubTitle: String) {
        self.init(headerTitle: headerTitle, headerSubTitle: headerSubTitle, enabledExtension: AdMobExtension.self)
    }
}
