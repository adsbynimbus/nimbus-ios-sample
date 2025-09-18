//
//  MolocoNativeViewController.swift
//  Nimbus
//  Created on 5/29/25
//  Copyright © 2025 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import NimbusKit
import MolocoSDK
import NimbusCoreKit
#if canImport(NimbusSDK) // CocoaPods
import NimbusSDK
#elseif canImport(NimbusMolocoKit) // Swift Package Manager
import NimbusMolocoKit
#endif

fileprivate var adUnitId = Bundle.main.infoDictionary?["Moloco Native ID"] as! String

final class MolocoNativeViewController: MolocoViewController {

    private var nativeAd: InlineAd?
    
    let contentView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MolocoExtension.nativeAdViewProvider = { _, assets in
            MolocoNativeAdView(assets: assets)
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
            nativeAd = try await Nimbus.nativeAd(position: "native") {
                demand {
                    moloco(adUnitId: adUnitId)
                }
            }
            .onEvent { [weak self] event in
                self?.didReceiveNimbusEvent(event: event)
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
