//
//  InterstitialAdViewRepresentable.swift
//  AdMobSwiftUISample
//  Created on 9/30/24
//  Copyright © 2024 Nimbus Advertising Solutions Inc. All rights reserved.
//

import SwiftUI
import NimbusKit

struct InterstitialAdViewRepresentable: UIViewControllerRepresentable {
    @ObservedObject var viewModel: AdManagerViewModel
    let closeButtonDelay: TimeInterval?
    
    init(viewModel: AdManagerViewModel, closeButtonDelay: TimeInterval? = nil) {
        self.viewModel = viewModel
        self.closeButtonDelay = closeButtonDelay
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let vc = UIViewController()
        
        viewModel.showBlockingAd(adPresentingViewController: vc, closeButtonDelay: closeButtonDelay)
        
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

#Preview {
    InterstitialAdViewRepresentable(
        viewModel: AdManagerViewModel(request: .forInterstitialAd(position: "")),
        closeButtonDelay: 5
    )
}
