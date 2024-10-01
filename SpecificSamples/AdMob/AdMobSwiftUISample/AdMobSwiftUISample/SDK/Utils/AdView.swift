//
//  AdView.swift
//  AdMobSwiftUISample
//  Created on 9/30/24
//  Copyright © 2024 Nimbus Advertising Solutions Inc. All rights reserved.
//

import SwiftUI
import NimbusKit

protocol AdView: View {
    var adCallbacks: AdManagerViewModel.Callbacks { get set }
}

extension AdView {
    func onEvent(perform action: @escaping (NimbusEvent) -> Void) -> Self {
        then({ $0.adCallbacks.onEvent = action })
    }
    
    func onRender(perform action: @escaping (NimbusRequest, NimbusAd, AdController) -> Void) -> Self {
        then({ $0.adCallbacks.onRender = action })
    }
    
    func onError(perform action: @escaping (NimbusError) -> Void) -> Self {
        then({ $0.adCallbacks.onError = action })
    }
    
    func onRequestCompletion(perform action: @escaping (NimbusRequest, NimbusAd) -> Void) -> Self {
        then({ $0.adCallbacks.onRequestCompletion = action })
    }
}
