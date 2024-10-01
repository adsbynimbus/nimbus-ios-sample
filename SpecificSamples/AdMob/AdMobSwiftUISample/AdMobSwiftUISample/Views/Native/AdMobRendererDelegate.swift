//
//  AdMobRendererDelegate.swift
//  AdMobSwiftUISample
//  Created on 9/30/24
//  Copyright © 2024 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import NimbusKit
import NimbusAdMobKit
import GoogleMobileAds

class AdMobRendererDelegate: NimbusAdMobAdRendererDelegate {
    func nativeAdViewForRendering(container: UIView, nativeAd: GADNativeAd) -> GADNativeAdView {
        NimbusNativeAdViewTemplate(nativeAd: nativeAd)
    }
}
