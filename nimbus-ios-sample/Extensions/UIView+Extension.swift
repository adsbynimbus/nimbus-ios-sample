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
    
    func setUiTestIdentifiers(for nimbusAd: NimbusAd, refreshing: Bool = false) {
        var dimens = ""
        if let width = nimbusAd.adDimensions?.width, let height = nimbusAd.adDimensions?.height {
            dimens = " \(width)x\(height)"
        }
        setUiTestIdentifiers(
            for: "\(nimbusAd.network) \(nimbusAd.auctionType.rawValue)\(dimens)",
            id: refreshing ? "nimbus_refreshing_controller" : "nimbus_ad_view"
        )
    }
    
    func setUiTestIdentifiers(for adString: String, id: String) {
        accessibilityContainerType = .semanticGroup
        accessibilityIdentifier = id
        accessibilityLabel = adString
        accessibilityValue = adString
        subviews.forEach {
            if #available(macOS 13.3, iOS 16.4, tvOS 16.4, *), let webView = $0 as? WKWebView {
                webView.isInspectable = true
            }
        }
    }
}
