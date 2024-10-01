//
//  RewardedAdViewRepresentable.swift
//  AdMobSwiftUISample
//  Created on 9/30/24
//  Copyright © 2024 Nimbus Advertising Solutions Inc. All rights reserved.
//

import SwiftUI
import NimbusKit

struct RewardedAdViewRepresentable: UIViewControllerRepresentable {
    @ObservedObject var viewModel: AdManagerViewModel
    
    init(viewModel: AdManagerViewModel) {
        self.viewModel = viewModel
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let vc = UIViewController()
        
        viewModel.showRewardedAd(adPresentingViewController: vc)
        
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

#Preview {
    RewardedAdViewRepresentable(
        viewModel: AdManagerViewModel(request: .forInterstitialAd(position: ""))
    )
}
