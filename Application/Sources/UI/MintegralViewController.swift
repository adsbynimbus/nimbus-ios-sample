//
//  MintegralViewController.swift
//  Nimbus
//  Created on 10/31/24
//  Copyright © 2024 Nimbus Advertising Solutions Inc. All rights reserved.
//

///  When integrating Mintegral, consider examples like MintegralBannerViewController inherit from UIViewController.
///  Both DemandViewController and MintegralViewController just facilitate the needs of the sample app.
class MintegralViewController: DemandViewController {
    convenience init(headerTitle: String, headerSubTitle: String) {
        self.init(network: .mintegral, headerTitle: headerTitle, headerSubTitle: headerSubTitle)
    }
}
