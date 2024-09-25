//
//  AdMobSwiftUISampleApp.swift
//  AdMobSwiftUISample
//  Created on 9/19/24
//  Copyright © 2024 Nimbus Advertising Solutions Inc. All rights reserved.
//

import SwiftUI
import NimbusKit
import NimbusAdMobKit

@main
struct AdMobSwiftUISampleApp: App {
    init () {
        Nimbus.shared.initialize(publisher: "dev-sdk", apiKey: "d352cac1-cae2-4774-97ba-4e15c6276be0")

        Nimbus.shared.logLevel = .info
        Nimbus.shared.testMode = true
        
        if let publisherKey = Nimbus.shared.publisher, Nimbus.shared.testMode {
            NimbusAdManager.requestUrl = URL(string: "https://\(publisherKey).adsbynimbus.com/rta/test")!
        }
        
        Nimbus.shared.renderers[.forNetwork("admob")] = NimbusAdMobAdRenderer()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
