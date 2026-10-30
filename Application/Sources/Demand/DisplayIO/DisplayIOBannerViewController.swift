//
//  DisplayIOBannerViewController.swift
//  Nimbus
//  Created on 7/8/26
//  Copyright © 2026 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import NimbusKit
import NimbusDisplayIOKit

final class DisplayIOBannerViewController: SampleAdViewController {

    private var bannerAd: InlineAd?
    let contentView = UIView()
    let size: AdSize
    
    init(headerTitle: String, headerSubTitle: String, size: AdSize) {
        self.size = size
        super.init(
            headerTitle: headerTitle,
            headerSubTitle: headerSubTitle,
            requiredExtension: DisplayIOExtension.self
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        Task { await showAd() }
    }
    
    func showAd() async {
        do {
            bannerAd = try await Nimbus.bannerAd(position: "banner", size: size, refreshInterval: 0)
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
