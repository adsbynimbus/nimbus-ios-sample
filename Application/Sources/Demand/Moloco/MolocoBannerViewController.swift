//
//  MolocoBannerViewController.swift
//  Nimbus
//  Created on 5/28/25
//  Copyright © 2025 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import NimbusKit

fileprivate var adUnitId = Bundle.main.infoDictionary?["Moloco Banner ID"] as! String

final class MolocoBannerViewController: MolocoViewController {

    private let adManager = NimbusAdManager()
    private var adController: AdController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adManager.delegate = self
        adManager.showAd(
            request: NimbusRequest.forBannerAd(position: "banner").withMoloco(adUnitId: adUnitId),
            container: view,
            refreshInterval: 30,
            adPresentingViewController: self
        )
    }
}

extension MolocoBannerViewController: NimbusAdManagerDelegate {
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
