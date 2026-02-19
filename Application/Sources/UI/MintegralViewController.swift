//
//  MintegralViewController.swift
//  Nimbus
//  Created on 10/31/24
//  Copyright © 2024 Nimbus Advertising Solutions Inc. All rights reserved.
//

import NimbusMintegralKit

///  When integrating Mintegral, consider examples like MintegralBannerViewController inherit from UIViewController.
///  Both SampleAdViewController and MintegralViewController just facilitate the needs of the sample app.
class MintegralViewController: SampleAdViewController {
    convenience init(headerTitle: String, headerSubTitle: String) {
        self.init(headerTitle: headerTitle, headerSubTitle: headerSubTitle, enabledExtension: MintegralExtension.self)
    }
}
