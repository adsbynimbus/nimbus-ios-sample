//
//  UIView+Extension.swift
//  nimbus-ios-sample
//
//  Created by Jason Sznol on 5/8/23.
//

import NimbusRenderKit
import UIKit

extension UIView {
    
    func setUiTestIdenfifiers(for nimbusAd: NimbusAd) {
        isAccessibilityElement = true
        accessibilityIdentifier = "nimbus_ad_view"
        accessibilityLabel = "\(nimbusAd.network) \(nimbusAd.auctionType.rawValue) ad"
    }
}
