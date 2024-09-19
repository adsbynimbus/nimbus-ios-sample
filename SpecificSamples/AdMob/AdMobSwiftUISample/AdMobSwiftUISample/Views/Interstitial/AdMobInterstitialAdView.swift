//
//  AdMobInterstitialAdView.swift
//  AdMobSwiftUISample
//  Created on 9/19/24
//  Copyright © 2024 Nimbus Advertising Solutions Inc. All rights reserved.
//
import SwiftUI
import NimbusKit
import NimbusAdMobKit

struct AdMobInterstitialAdView: UIViewControllerRepresentable {
    @ObservedObject var viewModel: AdManagerViewModel
    let position: String
    let adUnitId: String
    
    func makeUIViewController(context: Context) -> UIViewController {
        let vc = UIViewController()

        let request = NimbusRequest
            .forInterstitialAd(position: position)
            .withAdMobInterstitial(adUnitId: adUnitId)
        request.impressions[0].video = nil

        viewModel.adManager.showBlockingAd(request: request, adPresentingViewController: vc)
        
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

#Preview {
    AdMobInterstitialAdView(viewModel: AdManagerViewModel(), position: "", adUnitId: interstitialAdUnitId)
}
