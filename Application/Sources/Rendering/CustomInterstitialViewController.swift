//
//  CustomInterstitialViewController.swift
//  Nimbus
//  Created on 9/3/25
//  Copyright © 2025 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import NimbusKit

final class CustomInterstitialViewController: SampleAdViewController {
    var interstitialAd: InterstitialAd?
    let kind: Kind
    
    enum Kind: String {
        case staticOnly = "Static Interstitial"
        case videoOnly = "Video Interstitial"
    }
    
    init(headerTitle: String, kind: Kind) {
        self.kind = kind
        super.init(headerTitle: headerTitle, headerSubTitle: kind.rawValue, enabledExtension: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task { await showAd() }
    }
    
    func showAd() async {
        do {
            interstitialAd = try await Nimbus.fullscreenAd(position: kind.rawValue) {
                switch kind {
                case .staticOnly: banner(size: .interstitial)
                case .videoOnly: video()
                }
            }
            .onEvent { [weak self] event in
                self?.didReceiveNimbusEvent(event: event, ad: self?.interstitialAd)
            }
            .onError { [weak self] error in
                self?.didReceiveNimbusError(error: error)
            }
            .show(in: self, closeButtonDelay: 0)
        } catch {
            print("Couldn't show ad: \(error)")
        }
    }
}
