//
//  MolocoBannerViewController.swift
//  Nimbus
//  Created on 5/28/25
//  Copyright © 2025 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import NimbusKit
import NimbusMolocoKit

final class MolocoBannerViewController: SampleAdViewController {

    private var bannerAd: InlineAd?
    private let size: AdSize
    
    init(headerTitle: String, headerSubTitle: String, size: AdSize) {
        self.size = size
        super.init(
            headerTitle: headerTitle,
            headerSubTitle: headerSubTitle,
            requiredExtension: MolocoExtension.self
        )
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
            bannerAd = try await Nimbus.bannerAd(position: "banner", size: size, refreshInterval: 30)
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
