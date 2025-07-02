//
//  MolocoNativeViewController.swift
//  Nimbus
//  Created on 5/29/25
//  Copyright © 2025 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import NimbusKit
import MolocoSDK
#if canImport(NimbusSDK) // CocoaPods
import NimbusSDK
#else // Swift Package Manager
import NimbusMolocoKit
#endif

fileprivate var adUnitId = Bundle.main.infoDictionary?["Moloco Native ID"] as! String

final class MolocoNativeViewController: MolocoViewController {

    private let adManager = NimbusAdManager()
    private var adController: AdController?
    
    let contentView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let renderer = Nimbus.shared.renderers[.moloco] as? NimbusMolocoAdRenderer {
            renderer.adRendererDelegate = self
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
        
        adManager.delegate = self
        adManager.showAd(
            request: NimbusRequest.forNativeAd(position: "native").withMoloco(adUnitId: adUnitId),
            container: contentView,
            adPresentingViewController: self
        )
    }
}

extension MolocoNativeViewController: NimbusAdManagerDelegate {
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

extension MolocoNativeViewController: NimbusMolocoAdRendererDelegate {
    func nativeAdViewForRendering(container: UIView, assets: any MolocoNativeAdAssests) -> NimbusMolocoNativeAdViewType {
        MolocoNativeAdView(assets: assets)
    }
}
