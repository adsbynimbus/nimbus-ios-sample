//
//  NativeAdView.swift
//  AdMobSwiftUISample
//  Created on 9/19/24
//  Copyright © 2024 Nimbus Advertising Solutions Inc. All rights reserved.
//

import SwiftUI
import GoogleMobileAds
import NimbusAdMobKit
import NimbusKit

struct NativeAdView: View {
    var body: some View {
        NimbusInlineAdView(request:
                .forNativeAd(position: "native")
                .withAdMobNative(
                    adUnitId: nativeAdUnitId,
                    nativeAdOptions: NimbusAdMobNativeAdOptions(preferredAdChoicesPosition: .topLeftCorner)
                )
        )
        .onRender { request, ad, controller in
            print("Rendered Nimbus ad: \(ad)")
        }
        .onEvent { event in
            print("Received Nimbus event: \(event)")
        }
        .onError { error in
            print("Received Nimbus error: \(error.localizedDescription)")
        }
    }
}

#Preview {
    NativeAdView()
}
