//
//  InMobiBannerViewController.swift
//  Nimbus
//  Created on 7/31/25
//  Copyright © 2025 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import Nimbus
#if canImport(NimbusSDK) // CocoaPods
import NimbusSDK
#else                    // Swift Package Manager
import NimbusInMobiKit
#endif

fileprivate var placementId = Int(Bundle.main.infoDictionary?["InMobi Banner ID"] as! String)!

final class InMobiBannerViewController: InMobiViewController {

    private var bannerAd: InlineAd?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task { await showAd() }
    }
    
    func showAd() async {
        do {
            bannerAd = try await Nimbus.bannerAd(position: "banner", refreshInterval: 30) {
                demand {
                    inmobi(placementId: placementId)
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
            print("Failed to show ad: \(error)")
        }
    }
}
