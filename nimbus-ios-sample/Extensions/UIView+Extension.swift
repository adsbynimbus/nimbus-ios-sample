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
        setUiTestIdentifiers(for: "\(nimbusAd.network) \(nimbusAd.auctionType.rawValue) ad")
    }
    
    func setUiTestIdentifiers(for adString: String) {
        isAccessibilityElement = true
        accessibilityIdentifier = "nimbus_ad_view"
        accessibilityLabel = adString
        accessibilityValue = adString
        subviews.forEach {
            $0.isAccessibilityElement = true
        }
    }
}
