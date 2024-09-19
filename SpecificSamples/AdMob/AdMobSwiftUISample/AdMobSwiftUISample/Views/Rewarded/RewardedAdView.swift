//
//  RewardedAdView.swift
//  AdMobSwiftUISample
//  Created on 9/19/24
//  Copyright © 2024 Nimbus Advertising Solutions Inc. All rights reserved.
//

import SwiftUI

struct RewardedAdView: View {
    @StateObject var adManager = AdManagerViewModel()
    
    var body: some View {
        if let error = adManager.error {
            Text("Ad request failed: \(error.localizedDescription)")
        } else {
            AdMobRewardedAdView(viewModel: adManager, position: "rewarded", adUnitId: rewardedAdUnitId)
        }
    }
}

#Preview {
    RewardedAdView(adManager: AdManagerViewModel())
}
