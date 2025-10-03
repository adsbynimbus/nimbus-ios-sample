//
//  BannerViewController.swift
//  Nimbus
//  Created on 9/2/25
//  Copyright © 2025 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import Nimbus

final class BannerViewController: SampleAdViewController {
    var bannerAd: InlineAd?
    let contentView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: Constants.headerOffset),
            contentView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            contentView.widthAnchor.constraint(greaterThanOrEqualToConstant: 320),
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),
        ])
        
        Task { await showAd() }
    }
    
    func showAd() async {
        do {
            bannerAd = try await Nimbus.bannerAd(position: "banner", refreshInterval: 30)
                .onEvent { [weak self] event in
                    self?.didReceiveNimbusEvent(event: event, ad: self?.bannerAd)
                }
                .onError { [weak self] error in
                    self?.didReceiveNimbusError(error: error)
                }
                .show(in: contentView)
        } catch {
            print("Couldn't show ad: \(error)")
        }
    }
}
