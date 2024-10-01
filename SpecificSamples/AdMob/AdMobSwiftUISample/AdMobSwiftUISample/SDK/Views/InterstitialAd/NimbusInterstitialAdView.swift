//
//  NimbusInterstitialAdView.swift
//  AdMobSwiftUISample
//  Created on 9/30/24
//  Copyright © 2024 Nimbus Advertising Solutions Inc. All rights reserved.
//

import SwiftUI
import NimbusKit

struct NimbusInterstitialAdView: AdView {
    @StateObject private var adManager: AdManagerViewModel
    
    let closeButtonDelay: TimeInterval?
    var adCallbacks = AdManagerViewModel.Callbacks()
    
    init(request: NimbusRequest, closeButtonDelay: TimeInterval? = nil) {
        _adManager = StateObject(wrappedValue: AdManagerViewModel(request: request))
        self.closeButtonDelay = closeButtonDelay
    }
    
    var body: some View {
        InterstitialAdViewRepresentable(viewModel: adManager, closeButtonDelay: closeButtonDelay)
            .onAppear {
                adManager.adCallbacks = adCallbacks
            }
    }
}

#Preview {
    NimbusInterstitialAdView(request: .forInterstitialAd(position: ""))
}
