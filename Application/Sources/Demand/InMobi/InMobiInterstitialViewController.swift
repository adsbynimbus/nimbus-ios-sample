//
//  InMobiInterstitialViewController.swift
//  Nimbus
//  Created on 7/31/25
//  Copyright © 2025 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import NimbusKit
#if canImport(NimbusSDK) // CocoaPods
import NimbusSDK
#else                    // Swift Package Manager
import NimbusInMobiKit
#endif

fileprivate var placementId = Int(Bundle.main.infoDictionary?["InMobi Interstitial ID"] as! String)!

final class InMobiInterstitialViewController: InMobiViewController {

    private let adManager = NimbusAdManager()
    private var adController: AdController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adManager.delegate = self
        
        adManager.showBlockingAd(
            request: .forInterstitialAd(position: "banner").withInMobi(placementId: placementId),
            adPresentingViewController: self
        )
    }
}

extension InMobiInterstitialViewController: NimbusAdManagerDelegate {
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
