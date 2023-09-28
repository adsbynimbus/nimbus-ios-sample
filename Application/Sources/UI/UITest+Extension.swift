//
//  UITest+Extension.swift
//  nimbus-ios-sample
//
//  Created by Jason Sznol on 5/8/23.
//

import NimbusRenderKit
import UIKit
import WebKit

extension NimbusAd {
    var testIdentifier: String {
        var dimens = ""
        if let width = adDimensions?.width, let height = adDimensions?.height {
            dimens = " \(width)x\(height)"
        }
        return "\(network) \(auctionType.rawValue)\(dimens)"
    }
}

extension UIView {
    
    func setUiTestIdentifiers(for nimbusAd: NimbusAd, refreshing: Bool = false) {
        setUiTestIdentifiers(
            for: nimbusAd.testIdentifier,
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
    
    func setCompanionAdUiTestIdentifiers(for nimbusAd: NimbusAd) {
        setUiTestIdentifiers(
            for: nimbusAd.testIdentifier,
            id: "nimbus_ad_view_companion"
        )
    }
}
