//
//  MolocoViewController.swift
//  Nimbus
//  Created on 5/28/25
//  Copyright © 2025 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import NimbusKit
#if canImport(NimbusSDK) // CocoaPods
import NimbusSDK
#elseif canImport(NimbusMolocoKit) // Swift Package Manager
import NimbusMolocoKit
#endif

///  When integrating Moloco, consider examples like MolocoBannerViewController inherit from UIViewController.
///  Both SampleAdViewController and MolocoViewController just facilitate the needs of the sample app.
class MolocoViewController: SampleAdViewController {
    convenience init(headerTitle: String, headerSubTitle: String) {
        self.init(headerTitle: headerTitle, headerSubTitle: headerSubTitle, enabledExtension: MolocoExtension.self)
    }
}
