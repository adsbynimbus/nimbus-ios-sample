//
//  DisplayIONativeViewController.swift
//  Nimbus
//  Created on 7/8/26
//  Copyright © 2025 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import NimbusKit
import IASDKCore
import NimbusDisplayIOKit

final class DisplayIONativeViewController: DisplayIOViewController {

    private var nativeAd: InlineAd?
    
    let contentView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DisplayIOExtension.nativeAdViewProvider = { container, ad in
            DisplayIONativeAdView(nativeAd: ad)
        }
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .clear
        
        view.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        Task { await showAd() }
    }
    
    func showAd() async {
        do {
            nativeAd = try await Nimbus.inlineAd(position: "native") {
                native()
            }
            .onEvent { [weak self] event in
                self?.didReceiveNimbusEvent(event: event, ad: self?.nativeAd)
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
