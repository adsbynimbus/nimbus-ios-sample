//
//  RewardedAdView.swift
//  AdMobSwiftUISample
//  Created on 9/19/24
//  Copyright © 2024 Nimbus Advertising Solutions Inc. All rights reserved.
//

import SwiftUI
import NimbusKit
import NimbusAdMobKit

struct RewardedAdView: View {
    var body: some View {
        NimbusRewardedAdView(request:
                .forRewardedVideo(position: "rewarded")
                .withAdMobRewarded(adUnitId: rewardedAdUnitId)
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
    RewardedAdView()
}
