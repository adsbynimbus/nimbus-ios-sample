//
//  DisplayIOBannerViewController.swift
//  Nimbus
//  Created on 7/8/26
//  Copyright © 2025 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import NimbusKit
import NimbusDTKit

final class DisplayIOBannerViewController: DisplayIOViewController {

    private var bannerAd: InlineAd?
    let contentView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        Task { await showAd() }
    }
    
    func showAd() async {
        do {
            bannerAd = try await Nimbus.bannerAd(position: "banner", size: .banner, refreshInterval: 0)
                .onEvent { [weak self] event in
                    self?.didReceiveNimbusEvent(event: event, ad: self?.bannerAd)
                }
                .onError { [weak self] error in
                    self?.didReceiveNimbusError(error: error)
                }
                .show(in: contentView)
        } catch {
            print("Failed to show ad: \(error)")
        }
    }
}
