//
//  InMobiViewController.swift
//  Nimbus
//  Created on 7/31/25
//  Copyright © 2025 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import NimbusKit

///  When integrating InMobi, consider examples like InMobiBannerViewController inherit from UIViewController.
///  Both DemandViewController and InMobiViewController just facilitate the needs of the sample app.
class InMobiViewController: DemandViewController {
    convenience init(headerTitle: String, headerSubTitle: String) {
        self.init(network: .inmobi, headerTitle: headerTitle, headerSubTitle: headerSubTitle)
    }
}
