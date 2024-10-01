//
//  NimbusRewardedAdView.swift
//  AdMobSwiftUISample
//  Created on 9/30/24
//  Copyright © 2024 Nimbus Advertising Solutions Inc. All rights reserved.
//

import SwiftUI
import NimbusKit

struct NimbusRewardedAdView: AdView {
    @StateObject private var adManager: AdManagerViewModel
    
    var adCallbacks = AdManagerViewModel.Callbacks()
    
    init(request: NimbusRequest) {
        _adManager = StateObject(wrappedValue: AdManagerViewModel(request: request))
    }
    
    var body: some View {
        RewardedAdViewRepresentable(viewModel: adManager)
            .onAppear {
                adManager.adCallbacks = adCallbacks
            }
    }
}

#Preview {
    NimbusRewardedAdView(request: .forRewardedVideo(position: ""))
}
