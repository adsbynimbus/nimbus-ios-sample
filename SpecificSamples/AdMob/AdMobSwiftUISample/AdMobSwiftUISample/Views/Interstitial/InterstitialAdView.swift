//
//  InterstitialAdView.swift
//  AdMobSwiftUISample
//  Created on 9/19/24
//  Copyright © 2024 Nimbus Advertising Solutions Inc. All rights reserved.
//

import SwiftUI

struct InterstitialAdView: View {
    @StateObject var adManager = AdManagerViewModel()
    
    var body: some View {
        if let error = adManager.error {
            Text("Ad request failed: \(error.localizedDescription)")
        } else {
            AdMobInterstitialAdView(
                viewModel: adManager,
                position: "interstitial",
                adUnitId: interstitialAdUnitId
            )
        }
    }
}

#Preview {
    InterstitialAdView()
}
