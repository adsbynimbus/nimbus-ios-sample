//
//  BannerAdView.swift
//  AdMobSwiftUISample
//  Created on 9/30/24
//  Copyright © 2024 Nimbus Advertising Solutions Inc. All rights reserved.
//

import SwiftUI
import NimbusKit
import NimbusAdMobKit

struct BannerAdView: View {
    var body: some View {
        NimbusInlineAdView(request:
                .forBannerAd(position: "banner")
                .withAdMobBanner(adUnitId: bannerAdUnitId)
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
        .frame(height: 50)
        .background(.gray)
    }
}

#Preview {
    BannerAdView()
}
