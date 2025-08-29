//
//  MintegralNativeViewController.swift
//  Nimbus
//  Created on 11/8/24
//  Copyright © 2024 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import NimbusKit
import NimbusCoreKit
import MTGSDK
#if canImport(NimbusSDK) // CocoaPods
import NimbusSDK
#elseif canImport(NimbusMintegralKit) // Swift Package Manager
import NimbusMintegralKit
#endif

class MintegralNativeViewController: MintegralViewController {
    var nativeAd: InlineAd?
    
    let contentView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MintegralExtension.nativeAdViewProvider = { _, campaign in
            MintegralNativeAdView(campaign: campaign)
        }
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
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
                    mintegral(adUnitId: "1541926")
                }
            }
            .show(in: contentView)
        } catch {
            Nimbus.Log.ad.debug("Failed to show ad: \(error)")
        }
    }
}
