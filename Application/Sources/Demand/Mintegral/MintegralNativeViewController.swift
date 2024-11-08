//
//  MintegralNativeViewController.swift
//  Nimbus
//  Created on 11/8/24
//  Copyright © 2024 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import NimbusKit
import MTGSDK
#if canImport(NimbusSDK) // CocoaPods
import NimbusSDK
#elseif canImport(NimbusMintegralKit) // Swift Package Manager
import NimbusMintegralKit
#endif

class MintegralNativeViewController: MintegralViewController {
    var adController: AdController?
    let adManager = NimbusAdManager()
    
    let contentView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let renderer = Nimbus.shared.renderers[.forNetwork(ThirdPartyDemandNetwork.mintegral)] as? NimbusMintegralAdRenderer {
            renderer.adRendererDelegate = self
        }
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        adManager.delegate = self
        adManager.showAd(
            request: NimbusRequest.forNativeAd(position: "native").withMintegral(adUnitId: "1541926"),
            container: contentView,
            adPresentingViewController: self
        )
    }
}

extension MintegralNativeViewController: NimbusAdManagerDelegate {
    func didRenderAd(request: NimbusRequest, ad: NimbusAd, controller: AdController) {
        print("didRenderAd")
        adController = controller
        adController?.delegate = self
        nimbusAd = ad
    }
    
    func didCompleteNimbusRequest(request: NimbusRequest, ad: NimbusAd) {
        print("didCompleteNimbusRequest")
    }
    
    func didFailNimbusRequest(request: NimbusRequest, error: NimbusError) {
        print("didFailNimbusRequest: \(error.localizedDescription)")
    }
}

extension MintegralNativeViewController: NimbusMintegralAdRendererDelegate {
    func nativeAdViewForRendering(container: UIView, campaign: MTGCampaign) -> any NimbusMintegralNativeAdViewType {
        MintegralNativeAdView(campaign: campaign)
    }
}
