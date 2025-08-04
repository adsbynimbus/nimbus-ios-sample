//
//  InMobiNativeViewController.swift
//  Nimbus
//  Created on 7/31/25
//  Copyright © 2025 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import NimbusKit
import InMobiSDK
#if canImport(NimbusSDK) // CocoaPods
import NimbusSDK
#else                    // Swift Package Manager
import NimbusInMobiKit
#endif

fileprivate var placementId = Int64(Bundle.main.infoDictionary?["InMobi Native ID"] as! String)!

final class InMobiNativeViewController: InMobiViewController, NimbusInMobiAdRendererDelegate {

    private let adManager = NimbusAdManager()
    private var adController: AdController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let contentView = UIView()
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentView)
        
        if let renderer = Nimbus.shared.renderers[.inmobi] as? NimbusInMobiAdRenderer {
            renderer.adRendererDelegate = self
        }
        
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
        ])
        
        adManager.delegate = self
        adManager.showAd(
            request: NimbusRequest.forNativeAd(position: "native").withInMobi(placementId: placementId),
            container: contentView,
            refreshInterval: 0,
            adPresentingViewController: self
        )
    }
    
    func nativeAdViewForRendering(container: UIView, nativeAd: InMobiSDK.IMNative) -> UIView {
        InMobiNativeAdView(nativeAd: nativeAd)
    }
}

extension InMobiNativeViewController: NimbusAdManagerDelegate {
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
