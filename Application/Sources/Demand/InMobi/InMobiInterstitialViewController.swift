//
//  InMobiInterstitialViewController.swift
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

fileprivate var placementId = Int(Bundle.main.infoDictionary?["InMobi Interstitial ID"] as! String)!

final class InMobiInterstitialViewController: InMobiViewController {

    private var interstitialAd: InterstitialAd?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task { await showAd() }
    }
    
    func showAd() async {
        do {
            interstitialAd = try await Nimbus.interstitialAd(position: "interstitial") {
                demand {
                    inmobi(placementId: placementId)
                }
            }
            .onEvent { [weak self] event in
                self?.didReceiveNimbusEvent(event: event, ad: self?.interstitialAd)
            }
            .onError { [weak self] error in
                self?.didReceiveNimbusError(error: error)
            }
            .show(in: self)
        } catch {
            
        }
    }
}
