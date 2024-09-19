//
//  AdMobBannerView.swift
//  AdMobSwiftUISample
//  Created on 9/19/24
//  Copyright © 2024 Nimbus Advertising Solutions Inc. All rights reserved.
//

import SwiftUI
import NimbusKit
import NimbusAdMobKit


struct AdMobBannerView: UIViewControllerRepresentable {
    @ObservedObject var viewModel: AdManagerViewModel
    let position: String
    let format: NimbusAdFormat
    let adUnitId: String
    
    init(viewModel: AdManagerViewModel, position: String, format: NimbusAdFormat = .banner320x50, adUnitId: String) {
        self.viewModel = viewModel
        self.position = position
        self.format = format
        self.adUnitId = adUnitId
    }

    func makeUIViewController(context: Context) -> some UIViewController {
        let vc = UIViewController()

        let request = NimbusRequest
            .forBannerAd(position: position, format: format)
            .withAdMobBanner(adUnitId: adUnitId)

        viewModel.adManager.showAd(
            request: request,
            container: vc.view,
            refreshInterval: 30,
            adPresentingViewController: vc
        )
        
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

#Preview {
    AdMobBannerView(
        viewModel: AdManagerViewModel(),
        position: "",
        format: .banner320x50,
        adUnitId: bannerAdUnitId
    )
}
