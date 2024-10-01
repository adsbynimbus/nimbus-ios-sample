//
//  AdManagerViewModel.swift
//  AdMobSwiftUISample
//  Created on 9/19/24
//  Copyright © 2024 Nimbus Advertising Solutions Inc. All rights reserved.
//

import SwiftUI
import NimbusKit

@MainActor
class AdManagerViewModel: ObservableObject {
    
    struct Callbacks {
        var onEvent: ((NimbusEvent) -> Void)?
        var onRender: ((NimbusRequest, NimbusAd, AdController) -> Void)?
        var onError: ((NimbusError) -> Void)?
        var onRequestCompletion: ((NimbusRequest, NimbusAd) -> Void)?
    }
    
    private let request: NimbusRequest
    private var adController: AdController?
    private let adManager = NimbusAdManager()
    
    var adCallbacks: Callbacks?
    
    init(request: NimbusRequest) {
        self.request = request
        self.adManager.delegate = self
    }
    
    func showAd(container: UIView, refreshInterval: TimeInterval, adPresentingViewController: UIViewController) {
        adManager.showAd(
            request: request,
            container: container,
            refreshInterval: refreshInterval,
            adPresentingViewController: adPresentingViewController
        )
    }
    
    func showBlockingAd(adPresentingViewController: UIViewController) {
        adManager.showBlockingAd(
            request: request,
            adPresentingViewController: adPresentingViewController
        )
    }
    
    func showBlockingAd(adPresentingViewController: UIViewController, closeButtonDelay: TimeInterval? = nil) {
        if let closeButtonDelay {
            adManager.showBlockingAd(
                request: request,
                closeButtonDelay: closeButtonDelay,
                adPresentingViewController: adPresentingViewController
            )
        } else {
            adManager.showBlockingAd(
                request: request,
                adPresentingViewController: adPresentingViewController
            )
        }
    }
    
    func showRewardedAd(adPresentingViewController: UIViewController) {
        adManager.showRewardedAd(request: request, adPresentingViewController: adPresentingViewController)
    }
}

extension AdManagerViewModel: NimbusAdManagerDelegate {
    nonisolated func didRenderAd(request: NimbusRequest, ad: NimbusAd, controller: AdController) {
        DispatchQueue.main.async {
            self.adController = controller
            self.adController?.delegate = self
            self.adCallbacks?.onRender?(request, ad, controller)
        }
    }
    
    nonisolated func didCompleteNimbusRequest(request: NimbusRequest, ad: NimbusAd) {
        DispatchQueue.main.async {
            self.adCallbacks?.onRequestCompletion?(request, ad)
        }
    }
    
    nonisolated func didFailNimbusRequest(request: NimbusRequest, error: any NimbusError) {
        DispatchQueue.main.async {
            self.adCallbacks?.onError?(error)
        }
    }
}

extension AdManagerViewModel: AdControllerDelegate {
    nonisolated func didReceiveNimbusEvent(controller: AdController, event: NimbusEvent) {
        DispatchQueue.main.async {
            self.adCallbacks?.onEvent?(event)
        }
    }
    
    nonisolated func didReceiveNimbusError(controller: AdController, error: NimbusError) {
        DispatchQueue.main.async {
            self.adCallbacks?.onError?(error)
        }
    }
}
