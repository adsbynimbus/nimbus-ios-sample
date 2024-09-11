//
//  AdMobNativeViewController.swift
//  NimbusInternalSampleApp
//  Created on 9/6/24
//  Copyright © 2024 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import NimbusKit
import GoogleMobileAds
#if canImport(NimbusSDK) // CocoaPods
import NimbusSDK
#elseif canImport(NimbusAdMobKit) // Swift Package Manager
import NimbusAdMobKit
#endif

let nativePlacementId = Bundle.main.infoDictionary?["AdMob Native ID"] as? String ?? ""

class AdMobNativeViewController: AdMobViewController {

    var adController: AdController?
    let adManager = NimbusAdManager()
    var adLoader: GADAdLoader!
    var adView: AdMobNativeAdView!
    let contentView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let renderer = Nimbus.shared.renderers[.forNetwork("admob")] as? NimbusAdMobAdRenderer {
            renderer.adRendererDelegate = self
        }
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        adManager.showAd(
            request: .forNativeAd(position: "position").withAdMob(adUnitId: nativePlacementId, isBlocking: false),
            container: contentView,
            adPresentingViewController: self
        )
    }
}

extension AdMobNativeViewController: NimbusAdMobAdRendererDelegate {
    func nativeAdViewOptions() -> GADNativeAdViewAdOptions {
        GADNativeAdViewAdOptions.init()
    }
    
    func nativeAdViewForRendering(container: UIView, nativeAd: GADNativeAd) -> GADNativeAdView {
        AdMobNativeAdView(nativeAd: nativeAd)
    }
}
