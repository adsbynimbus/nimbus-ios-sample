//
//  InMobiViewController.swift
//  Nimbus
//  Created on 7/31/25
//  Copyright © 2025 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import NimbusKit
import NimbusInMobiKit

///  When integrating InMobi, consider examples like InMobiBannerViewController inherit from UIViewController.
///  Both SampleAdViewController and InMobiViewController just facilitate the needs of the sample app.
class InMobiViewController: SampleAdViewController {
    convenience init(headerTitle: String, headerSubTitle: String) {
        self.init(headerTitle: headerTitle, headerSubTitle: headerSubTitle, enabledExtension: InMobiExtension.self)
    }
}
