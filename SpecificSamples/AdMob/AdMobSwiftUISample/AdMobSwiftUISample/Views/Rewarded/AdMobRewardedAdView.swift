//
//  AdMobRewardedAdView.swift
//  AdMobSwiftUISample
//  Created on 9/19/24
//  Copyright © 2024 Nimbus Advertising Solutions Inc. All rights reserved.
//
import SwiftUI
import NimbusKit
import NimbusAdMobKit

struct AdMobRewardedAdView: UIViewControllerRepresentable {
    @ObservedObject var viewModel: AdManagerViewModel
    let position: String
    let adUnitId: String
    
    func makeUIViewController(context: Context) -> UIViewController {
        let vc = UIViewController()

        let request = NimbusRequest
            .forRewardedVideo(position: position)
            .withAdMobRewarded(adUnitId: adUnitId)

        viewModel.adManager.showRewardedAd(request: request, adPresentingViewController: vc)
        
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

#Preview {
    AdMobRewardedAdView(
        viewModel: AdManagerViewModel(),
        position: "",
        adUnitId: rewardedAdUnitId
    )
    
}

