//
//  InlineAdViewRepresentable.swift
//  AdMobSwiftUISample
//  Created on 9/30/24
//  Copyright © 2024 Nimbus Advertising Solutions Inc. All rights reserved.
//

import SwiftUI
import NimbusKit
import NimbusAdMobKit

struct InlineAdViewRepresentable: UIViewControllerRepresentable {
    @ObservedObject private var viewModel: AdManagerViewModel
    private let refreshInterval: TimeInterval
    
    init(viewModel: AdManagerViewModel, refreshInterval: TimeInterval = 0) {
        self.viewModel = viewModel
        self.refreshInterval = refreshInterval
    }

    func makeUIViewController(context: Context) -> some UIViewController {
        let vc = UIViewController()

        viewModel.showAd(
            container: vc.view,
            refreshInterval: refreshInterval,
            adPresentingViewController: vc
        )
        
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

#Preview {
    InlineAdViewRepresentable(
        viewModel: AdManagerViewModel(request: .forBannerAd(position: ""))
    )
}
