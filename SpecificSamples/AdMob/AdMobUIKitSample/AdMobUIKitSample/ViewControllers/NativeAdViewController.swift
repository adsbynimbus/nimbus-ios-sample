//
//  NativeAdViewController.swift
//  AdMobUIKitSample
//  Created on 9/19/24
//  Copyright © 2024 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import NimbusKit
import GoogleMobileAds
import NimbusSDK

class NativeAdViewController: UIViewController {
    var adController: AdController?
    let adManager = NimbusAdManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Native Ad"

        if let renderer = Nimbus.shared.renderers[.forNetwork("admob")] as? NimbusAdMobAdRenderer {
            renderer.adRendererDelegate = self
        }
        
        /// Shows how to pass AdMob native ad options, like changing the adChoices position.
        let nativeOptions = NimbusAdMobNativeAdOptions(preferredAdChoicesPosition: .topLeftCorner)
        
        adManager.delegate = self
        adManager.showAd(
            request: .forNativeAd(position: "position")
                .withAdMobNative(adUnitId: nativeAdUnitId, nativeAdOptions: nativeOptions),
            container: view,
            adPresentingViewController: self
        )
    }
}

extension NativeAdViewController: NimbusAdMobAdRendererDelegate {
    func nativeAdViewForRendering(container: UIView, nativeAd: GADNativeAd) -> GADNativeAdView {
        NimbusNativeAdViewTemplate(nativeAd: nativeAd)
    }
}

extension NativeAdViewController: NimbusAdManagerDelegate {
    func didRenderAd(request: NimbusRequest, ad: NimbusAd, controller: AdController) {
        print("didRenderAd")
        adController = controller
        adController?.delegate = self
    }
    
    func didCompleteNimbusRequest(request: NimbusRequest, ad: NimbusAd) {
        print("didCompleteNimbusRequest")
    }
    
    func didFailNimbusRequest(request: NimbusRequest, error: NimbusError) {
        print("didFailNimbusRequest: \(error.localizedDescription)")
    }
}

extension NativeAdViewController: AdControllerDelegate {
    func didReceiveNimbusEvent(controller: any NimbusCoreKit.AdController, event: NimbusCoreKit.NimbusEvent) {
        print("Received Nimbus event: \(event)")
    }
    
    func didReceiveNimbusError(controller: any NimbusCoreKit.AdController, error: any NimbusCoreKit.NimbusError) {
        print("Received Nimbus error: \(error.localizedDescription)")
    }
}
