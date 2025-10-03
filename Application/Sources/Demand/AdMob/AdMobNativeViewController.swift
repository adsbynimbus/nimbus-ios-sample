//
//  AdMobNativeViewController.swift
//  NimbusInternalSampleApp
//  Created on 9/6/24
//  Copyright © 2024 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import NimbusKit
import GoogleMobileAds
#if canImport(NimbusSDK) // CocoaPods
import NimbusSDK
#elseif canImport(NimbusAdMobKit) // Swift Package Manager
import NimbusAdMobKit
#endif

let nativePlacementId = Bundle.main.infoDictionary?["AdMob Native ID"] as? String ?? ""

class AdMobNativeViewController: AdMobViewController {
    
    var nativeAd: InlineAd?
    
    var adView: AdMobNativeAdView!
    let contentView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        AdMobExtension.nativeAdViewProvider = { _, nativeAd in
            AdMobNativeAdView(nativeAd: nativeAd)
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
            /// Shows how to pass AdMob native ad options, like changing the adChoices position.
            let nativeOptions = NimbusAdMobNativeAdOptions(preferredAdChoicesPosition: .topLeftCorner)
            
            self.nativeAd = try await Nimbus.nativeAd(position: "native") {
                demand {
                    admob(nativeAdUnitId: nativePlacementId, options: nativeOptions)
                }
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
