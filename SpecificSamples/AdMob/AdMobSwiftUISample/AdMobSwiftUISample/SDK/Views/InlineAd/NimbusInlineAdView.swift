//
//  NimbusInlineAdView.swift
//  AdMobSwiftUISample
//  Created on 9/19/24
//  Copyright © 2024 Nimbus Advertising Solutions Inc. All rights reserved.
//

import SwiftUI
import NimbusKit

struct NimbusInlineAdView: AdView {
    @StateObject private var adManager: AdManagerViewModel
    
    var adCallbacks = AdManagerViewModel.Callbacks()
    let refreshInterval: TimeInterval
    
    init(request: NimbusRequest, refreshInterval: TimeInterval = 0) {
        _adManager = StateObject(wrappedValue: AdManagerViewModel(request: request))
        self.refreshInterval = refreshInterval
    }
    
    var body: some View {
        InlineAdViewRepresentable(viewModel: adManager, refreshInterval: refreshInterval)
            .onAppear {
                adManager.adCallbacks = adCallbacks
            }
    }
}

#Preview {
    NimbusInlineAdView(request: .forBannerAd(position: ""))
}
