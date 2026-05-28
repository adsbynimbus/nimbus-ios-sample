//
//  DTViewController.swift
//  Nimbus
//  Created on 5/27/26
//  Copyright © 2026 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import NimbusKit
import NimbusDTKit

///  When integrating Digital Turbine, consider examples like DTBannerViewController inherit from UIViewController.
///  Both SampleAdViewController and DTViewController just facilitate the needs of the sample app.
class DTViewController: SampleAdViewController {
    convenience init(headerTitle: String, headerSubTitle: String) {
        self.init(headerTitle: headerTitle, headerSubTitle: headerSubTitle, enabledExtension: DigitalTurbineExtension.self)
    }
}
