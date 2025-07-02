//
//  MolocoViewController.swift
//  Nimbus
//  Created on 5/28/25
//  Copyright © 2025 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import NimbusKit

///  When integrating Moloco, consider examples like MolocoBannerViewController inherit from UIViewController.
///  Both DemandViewController and MolocoViewController just facilitate the needs of the sample app.
class MolocoViewController: DemandViewController {
    convenience init(headerTitle: String, headerSubTitle: String) {
        self.init(network: .moloco, headerTitle: headerTitle, headerSubTitle: headerSubTitle)
    }
}
