//
//  NativeAdView.swift
//  AdMobSwiftUISample
//  Created on 9/19/24
//  Copyright © 2024 Nimbus Advertising Solutions Inc. All rights reserved.
//

import SwiftUI
import GoogleMobileAds
import NimbusAdMobKit

struct NativeAdView: View {
    @StateObject var adManager = AdManagerViewModel()
    
    var body: some View {
        if let error = adManager.error {
            Text("Ad request failed: \(error.localizedDescription)")
        } else {
            AdMobNativeAdView(
                viewModel: adManager,
                position: "native",
                adUnitId: nativeAdUnitId,
                options: .init(preferredAdChoicesPosition: .topLeftCorner)
            )
        }
    }
}

#Preview {
    AdMobNativeAdView(
        viewModel: AdManagerViewModel(),
        position: "",
        adUnitId: nativeAdUnitId,
        options: nil
    )
}
