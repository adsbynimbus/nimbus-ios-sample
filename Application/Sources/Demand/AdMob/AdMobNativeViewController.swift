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
    var adView: AdMobNativeAdView!
    let contentView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        AdMobExtension.nativeAdViewProvider = { _, nativeAd in
            AdMobNativeAdView(nativeAd: nativeAd)
        }
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .clear
        
        view.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        /// Shows how to pass AdMob native ad options, like changing the adChoices position.
        let nativeOptions = NimbusAdMobNativeAdOptions(preferredAdChoicesPosition: .topLeftCorner)
        
        adManager.delegate = self
        adManager.showAd(
            request: .forNativeAd(position: "position")
                .withAdMobNative(adUnitId: nativePlacementId, nativeAdOptions: nativeOptions),
            container: contentView,
            adPresentingViewController: self
        )
    }
}

extension AdMobNativeViewController: NimbusAdManagerDelegate {
    func didRenderAd(request: NimbusRequest, ad: NimbusAd, controller: AdController) {
        print("didRenderAd")
        adController = controller
        adController?.register(delegate: self)
        nimbusAd = ad
    }
    
    func didCompleteNimbusRequest(request: NimbusRequest, ad: NimbusAd) {
        print("didCompleteNimbusRequest")
    }
    
    func didFailNimbusRequest(request: NimbusRequest, error: NimbusError) {
        print("didFailNimbusRequest: \(error.localizedDescription)")
    }
}
