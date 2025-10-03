//
//  UITest+Extension.swift
//  nimbus-ios-sample
//
//  Created on 5/8/23.
//

import Nimbus
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
    func makeWebViewInspectable() {
        subviews.forEach {
            if #available(macOS 13.3, iOS 16.4, tvOS 16.4, *), let webView = $0 as? WKWebView {
                webView.isInspectable = true
            }
        }
    }
}
