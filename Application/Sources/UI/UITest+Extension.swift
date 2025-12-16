//
//  UITest+Extension.swift
//  nimbus-ios-sample
//
//  Created on 5/8/23.
//

import NimbusKit
import UIKit
import WebKit

extension NimbusResponse {
    var testIdentifier: String {
        var dimens = ""
        if let width = bid.adDimensions?.width, let height = bid.adDimensions?.height {
            dimens = " \(width)x\(height)"
        }
        return "\(bid.ext?.omp?.buyer ?? "") \(bid.mtype.stringValue)\(dimens)"
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
