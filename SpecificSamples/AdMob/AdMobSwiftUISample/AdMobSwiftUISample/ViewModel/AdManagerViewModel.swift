//
//  AdManagerViewModel.swift
//  AdMobSwiftUISample
//  Created on 9/19/24
//  Copyright © 2024 Nimbus Advertising Solutions Inc. All rights reserved.
//

import SwiftUI
import NimbusKit

class AdManagerViewModel: ObservableObject {
    
    @Published var error: Error?
    var adController: AdController?
    let adManager = NimbusAdManager()
    
    init() {
        adManager.delegate = self
    }
}

extension AdManagerViewModel: NimbusAdManagerDelegate {
    func didRenderAd(request: NimbusRequest, ad: NimbusAd, controller: AdController) {
        DispatchQueue.main.async {
            self.adController = controller
            self.adController?.delegate = self
        }
    }
    
    func didCompleteNimbusRequest(request: NimbusRequest, ad: NimbusAd) {
        print("\(#function)")
    }
    
    func didFailNimbusRequest(request: NimbusRequest, error: any NimbusError) {
        print("\(#function)")
        DispatchQueue.main.async {
            self.error = error
        }
    }
}

extension AdManagerViewModel: AdControllerDelegate {
    func didReceiveNimbusEvent(controller: AdController, event: NimbusEvent) {
        print("Received Nimbus event: \(event)")
    }
    
    func didReceiveNimbusError(controller: AdController, error: NimbusError) {
        print("\(#function)")
        DispatchQueue.main.async {
            self.error = error
        }
    }
}
