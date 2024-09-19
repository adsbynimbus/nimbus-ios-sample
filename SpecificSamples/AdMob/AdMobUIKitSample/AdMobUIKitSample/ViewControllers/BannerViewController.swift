//
//  BannerViewController.swift
//  AdMobUIKitSample
//  Created on 9/19/24
//  Copyright © 2024 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import NimbusKit
import NimbusSDK

class BannerViewController: UIViewController {
    var adController: AdController?
    let adManager = NimbusAdManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Banner Ad"
        
        adManager.delegate = self
        adManager.showAd(
            request: .forBannerAd(position: "banner").withAdMobBanner(adUnitId: bannerAdUnitId),
            container: view,
            refreshInterval: 30,
            adPresentingViewController: self
        )
    }
}

extension BannerViewController: NimbusAdManagerDelegate {
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

extension BannerViewController: AdControllerDelegate {
    func didReceiveNimbusEvent(controller: any NimbusCoreKit.AdController, event: NimbusCoreKit.NimbusEvent) {
        print("Received Nimbus event: \(event)")
    }
    
    func didReceiveNimbusError(controller: any NimbusCoreKit.AdController, error: any NimbusCoreKit.NimbusError) {
        print("Received Nimbus error: \(error.localizedDescription)")
    }
}

