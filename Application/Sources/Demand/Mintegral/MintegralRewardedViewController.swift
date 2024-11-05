//
//  MintegralRewardedViewController.swift
//  Nimbus
//  Created on 11/1/24
//  Copyright © 2024 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import NimbusKit
#if canImport(NimbusSDK) // CocoaPods
import NimbusSDK
#elseif canImport(NimbusMintegralKit) // Swift Package Manager
import NimbusMintegralKit
#endif

class MintegralRewardedViewController: MintegralViewController {
    var adController: AdController?
    let adManager = NimbusAdManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adManager.delegate = self
        adManager.showRewardedAd(request: .forRewardedVideo(position: "rewarded"), adPresentingViewController: self)
    }
}

extension MintegralRewardedViewController: NimbusAdManagerDelegate {
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
