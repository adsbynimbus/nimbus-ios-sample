//
//  UIView+Extension.swift
//  nimbus-ios-sample
//
//  Created by Jason Sznol on 5/8/23.
//

import NimbusRenderKit
import UIKit

extension UIView {
    
    func setUiTestIdentifiers(for nimbusAd: NimbusAd) {
        let adString = "\(nimbusAd.network) \(nimbusAd.auctionType.rawValue) ad"
        isAccessibilityElement = true
        accessibilityIdentifier = "nimbus_ad_view"
        accessibilityLabel = adString
        accessibilityValue = adString
    }
}
