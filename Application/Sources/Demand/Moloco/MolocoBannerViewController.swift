//
//  MolocoBannerViewController.swift
//  Nimbus
//  Created on 5/28/25
//  Copyright © 2025 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import NimbusKit
import NimbusCoreKit
#if canImport(NimbusSDK) // CocoaPods
import NimbusSDK
#elseif canImport(NimbusMolocoKit) // Swift Package Manager
import NimbusMolocoKit
#endif

fileprivate var adUnitId = Bundle.main.infoDictionary?["Moloco Banner ID"] as! String

final class MolocoBannerViewController: MolocoViewController {

    private var bannerAd: InlineAd?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task { await showAd() }
    }
    
    func showAd() async {
        do {
            bannerAd = try await Nimbus.bannerAd(position: "banner", refreshInterval: 30) {
                demand {
                    moloco(adUnitId: adUnitId)
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
