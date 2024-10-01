//
//  InterstitialAdView.swift
//  AdMobSwiftUISample
//  Created on 9/30/24
//  Copyright © 2024 Nimbus Advertising Solutions Inc. All rights reserved.
//

import SwiftUI
import NimbusKit
import NimbusAdMobKit

struct InterstitialAdView: View {
    var body: some View {
        NimbusInterstitialAdView(request:
                .forInterstitialAd(position: "interstitial")
                .withAdMobInterstitial(adUnitId: interstitialAdUnitId)
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
    InterstitialAdView()
}
