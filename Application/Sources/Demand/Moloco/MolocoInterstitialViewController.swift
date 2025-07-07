//
//  MolocoInterstitialViewController.swift
//  Nimbus
//  Created on 5/29/25
//  Copyright © 2025 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import NimbusKit

fileprivate var adUnitId = Bundle.main.infoDictionary?["Moloco Interstitial ID"] as! String

final class MolocoInterstitialViewController: MolocoViewController {

    private let adManager = NimbusAdManager()
    private var adController: AdController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adManager.delegate = self
        adManager.showBlockingAd(
            request: NimbusRequest.forInterstitialAd(position: "interstitial").withMoloco(adUnitId: adUnitId),
            adPresentingViewController: self
        )
    }
}

extension MolocoInterstitialViewController: NimbusAdManagerDelegate {
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
