//
//  MintegralBannerViewController.swift
//  Nimbus
//  Created on 10/30/24
//  Copyright © 2024 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import NimbusKit
import NimbusMintegralKit

class MintegralBannerViewController: SampleAdViewController {
    var bannerAd: InlineAd?
    
    convenience init(headerTitle: String, headerSubTitle: String) {
        self.init(
            headerTitle: headerTitle,
            headerSubTitle: headerSubTitle,
            requiredExtension: MintegralExtension.self
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task { await showAd() }
    }
    
    func showAd() async {
        do {
            self.bannerAd = try await Nimbus.bannerAd(position: "banner", size: .banner)
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
