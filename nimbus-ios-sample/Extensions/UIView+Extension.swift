//
//  UIView+Extension.swift
//  nimbus-ios-sample
//
//  Created by Jason Sznol on 5/8/23.
//

import NimbusRenderKit
import UIKit
import WebKit

extension UIView {
    
    func setUiTestIdentifiers(for nimbusAd: NimbusAd) {
        setUiTestIdentifiers(for: "\(nimbusAd.network) \(nimbusAd.auctionType.rawValue) ad")
    }
    
    func setUiTestIdentifiers(for adString: String) {
        accessibilityContainerType = .semanticGroup
        accessibilityIdentifier = "nimbus_ad_view"
        accessibilityLabel = adString
        accessibilityValue = adString
        subviews.forEach {
            $0.isAccessibilityElement = true
            if #available(macOS 13.3, iOS 16.4, tvOS 16.4, *), let webView = $0 as? WKWebView {
                webView.isInspectable = true
            }
        }
    }
}
