//
//  MobileFuseInterstitialViewController.swift
//  NimbusInternalSampleApp
//
//  Created on 9/13/23.
//  Copyright © 2023 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import NimbusKit
import NimbusCoreKit
#if canImport(NimbusSDK) // CocoaPods
import NimbusSDK
#elseif canImport(NimbusMobileFuseKit) // Swift Package Manager
import NimbusMobileFuseKit
#endif

final class MobileFuseInterstitialViewController: MobileFuseViewController {
    private var interstitialAd: InterstitialAd?
    
    init(headerTitle: String) {
        super.init(headerTitle: headerTitle, headerSubTitle: "")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task { await showAd() }
    }
    
    func showAd() async {
        do {
            self.interstitialAd = try await Nimbus.interstitialAd(position: "MobileFuse_Testing_INSTL_iOS_Nimbus")
                .show(in: self, closeButtonDelay: 0)
        } catch {
            Nimbus.Log.ad.error("Failed to show interstitial ad: \(error.localizedDescription)")
        }
    }
    
}
