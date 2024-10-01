//
//  ContentView.swift
//  AdMobSwiftUISample
//  Created on 9/19/24
//  Copyright © 2024 Nimbus Advertising Solutions Inc. All rights reserved.
//

import SwiftUI
import GoogleMobileAds

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                Section("Config (Keys.xcconfig)") {
                    ConfigValidationView()
                }
                
                Section("Ad Types") {
                    NavigationLink("Banner Ad") {
                        BannerAdView()
                    }
                    NavigationLink("Native Ad") {
                        NativeAdView()
                    }
                    NavigationLink("Interstitial Ad") {
                        InterstitialAdView()
                    }
                    NavigationLink("Rewarded Ad") {
                        RewardedAdView()
                    }
                }
            }
            .navigationTitle("AdMob Sample")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ContentView()
}
