//
//  BannerView.swift
//  AdMobSwiftUISample
//  Created on 9/19/24
//  Copyright © 2024 Nimbus Advertising Solutions Inc. All rights reserved.
//

import SwiftUI

struct BannerView: View {
    @StateObject var adManager = AdManagerViewModel()
    
    var body: some View {
        if let error = adManager.error {
            Text("Ad request failed: \(error.localizedDescription)")
        } else {
            VStack {
                AdMobBannerView(
                    viewModel: adManager,
                    position: "banner",
                    adUnitId: bannerAdUnitId
                ).frame(height: 50)
                Spacer()
            }
        }
    }
}

#Preview {
    BannerView()
}
