//
//  UnityViewController.swift
//  Nimbus
//  Created on 1/26/26
//  Copyright © 2026 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import NimbusKit
import NimbusUnityKit

///  When integrating Unity, consider examples like UnityBannerViewController inherit from UIViewController.
///  Both DemandViewController and UnityViewController just facilitate the needs of the sample app.
class UnityViewController: SampleAdViewController {
    convenience init(headerTitle: String, headerSubTitle: String) {
        self.init(headerTitle: headerTitle, headerSubTitle: headerSubTitle, enabledExtension: UnityExtension.self)
    }
}
