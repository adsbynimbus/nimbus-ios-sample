//
//  MintegralBannerViewController.swift
//  Nimbus
//  Created on 10/30/24
//  Copyright © 2024 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import NimbusKit
#if canImport(NimbusSDK) // CocoaPods
import NimbusSDK
#elseif canImport(NimbusMintegralKit) // Swift Package Manager
import NimbusMintegralKit
#endif

class MintegralBannerViewController: MintegralViewController {
    var bannerAd: InlineAd?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task { await showAd() }
    }
    
    func showAd() async {
        do {
            self.bannerAd = try await Nimbus.bannerAd(position: "banner") {
                demand {
                    mintegral(adUnitId: "1541918")
                }
            }
            .onEvent { [weak self] event in
                self?.didReceiveNimbusEvent(event: event, ad: self?.bannerAd)
            }
            .onError { [weak self] error in
                self?.didReceiveNimbusError(error: error)
            }
            .show(in: view)
        } catch {
            print("Couldn't show ad: \(error)")
        }
    }
}
