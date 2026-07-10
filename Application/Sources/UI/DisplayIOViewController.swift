//
//  DisplayIOViewController.swift
//  Nimbus
//  Created on 7/8/26
//  Copyright © 2026 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import NimbusKit
import NimbusDisplayIOKit

///  When integrating DisplayIO, consider examples like DisplayIOBannerViewController inherit from UIViewController.
///  Both SampleAdViewController and DisplayIOViewController just facilitate the needs of the sample app.
class DisplayIOViewController: SampleAdViewController {
    convenience init(headerTitle: String, headerSubTitle: String) {
        self.init(headerTitle: headerTitle, headerSubTitle: headerSubTitle, enabledExtension: DisplayIOExtension.self)
    }
}
