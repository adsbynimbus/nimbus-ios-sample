//
//  MetaViewController.swift
//  Nimbus
//  Created on 1/28/26
//  Copyright © 2026 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import NimbusKit
import NimbusMetaKit

///  When integrating Meta, consider examples like MetaBannerViewController inherit from UIViewController.
///  Both DemandViewController and MetaViewController just facilitate the needs of the sample app.
class MetaViewController: SampleAdViewController {
    convenience init(headerTitle: String, headerSubTitle: String) {
        self.init(headerTitle: headerTitle, headerSubTitle: headerSubTitle, enabledExtension: MetaExtension.self)
    }
}
