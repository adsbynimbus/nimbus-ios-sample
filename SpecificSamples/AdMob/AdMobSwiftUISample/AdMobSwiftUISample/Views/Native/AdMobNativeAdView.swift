//
//  AdMobNativeAdView.swift
//  AdMobSwiftUISample
//  Created on 9/19/24
//  Copyright © 2024 Nimbus Advertising Solutions Inc. All rights reserved.
//

import SwiftUI
import GoogleMobileAds
import NimbusKit
import NimbusAdMobKit

struct AdMobNativeAdView: UIViewControllerRepresentable {
    @ObservedObject var viewModel: AdManagerViewModel
    let position: String
    let adUnitId: String
    let options: NimbusAdMobNativeAdOptions?
    
    func makeUIViewController(context: Context) -> UIViewController {
        let vc = UIViewController()
        
        let request = NimbusRequest
            .forNativeAd(position: position)
            .withAdMobNative(adUnitId: adUnitId, nativeAdOptions: options)

        viewModel.adManager.showAd(request: request, container: vc.view, adPresentingViewController: vc)
        
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NimbusAdMobAdRendererDelegate {
        init() {
            guard let renderer = Nimbus.shared.renderers[.forNetwork("admob")] as? NimbusAdMobAdRenderer else {
                print("Error: NimbusAdMobAdRenderer was not installed. Native Ad won't be rendered.")
                return
            }
            
            renderer.adRendererDelegate = self
        }
        
        func nativeAdViewForRendering(container: UIView, nativeAd: GADNativeAd) -> GADNativeAdView {
            NimbusNativeAdViewTemplate(nativeAd: nativeAd)
        }
    }
}

