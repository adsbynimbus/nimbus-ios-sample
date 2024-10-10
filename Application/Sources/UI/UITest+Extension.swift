//
//  UITest+Extension.swift
//  nimbus-ios-sample
//
//  Created on 5/8/23.
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
