//
//  MobileFuseBannerViewController.swift
//  NimbusInternalSampleApp
//
//  Created on 9/15/23.
//  Copyright © 2023 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import NimbusKit

final class MobileFuseBannerViewController: MobileFuseViewController {

    private let adManager = NimbusAdManager()
    private var adController: AdController?
    private let position: String
    private let format: NimbusAdFormat
    
    init(headerTitle: String, position: String, format: NimbusAdFormat) {
        self.position = position
        self.format = format
        
        super.init(headerTitle: headerTitle, headerSubTitle: "")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adManager.delegate = self
        adManager.showAd(
            request: NimbusRequest.forBannerAd(position: position, format: format),
            container: view,
            refreshInterval: 30,
            adPresentingViewController: self
        )
    }
}

extension MobileFuseBannerViewController: NimbusAdManagerDelegate {
    func didRenderAd(request: NimbusRequest, ad: NimbusAd, controller: AdController) {
        print("didRenderAd")
        adController = controller
        adController?.delegate = self
        nimbusAd = ad
    }
    
    func didCompleteNimbusRequest(request: NimbusRequest, ad: NimbusAd) {
        print("didCompleteNimbusRequest")
    }
    
    func didFailNimbusRequest(request: NimbusRequest, error: NimbusError) {
        print("didFailNimbusRequest: \(error.localizedDescription)")
    }
}
