//
//  UnityViewController.swift
//  nimbus-ios-sample
//
//  Created by Victor Takai on 02/05/23.
//

import UIKit
import NimbusKit

#if canImport(NimbusSDK)
import NimbusSDK
#endif

#if canImport(NimbusUnityKit)
import NimbusUnityKit
#endif

final class UnityViewController: DemoViewController {

    private let adType: ThirdPartyDemandAdType
    private var adManager: NimbusAdManager?
    private var adController: AdController?

    init(
        adType: ThirdPartyDemandAdType,
        headerTitle: String,
        headerSubTitle: String
    ) {
        self.adType = adType
        
        super.init(headerTitle: headerTitle, headerSubTitle: headerSubTitle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
    
        setupRequestInterceptor()
        setupAdRendering()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // For testing purposes, this will clear all request interceptors
        DemoRequestInterceptors.shared.removeRequestInterceptors()
    }

    private func setupRequestInterceptor() {
        // For testing purposes, this ensures only the required interceptors will be set
        DemoRequestInterceptors.shared.setUnityRequestInterceptor()
    }
    
    private func setupAdRendering() {
        guard adType == .unityRewardedVideo else {
            return
        }
        
        adManager = NimbusAdManager()
        adManager?.delegate = self
        adManager?.showRewardedAd(
            request: NimbusRequest.forVideoAd(position: adType.description),
            adPresentingViewController: self
        )
    }
}

// MARK: NimbusAdManagerDelegate

extension UnityViewController: NimbusAdManagerDelegate {
  
    func didRenderAd(request: NimbusRequest, ad: NimbusAd, controller: AdController) {
        print("didRenderAd")
        
        adController = controller
        adController?.adView?.setUiTestIdentifiers(for: ad)
        adController?.delegate = self
    }
}

// MARK: NimbusRequestManagerDelegate

extension UnityViewController: NimbusRequestManagerDelegate {
    
    func didCompleteNimbusRequest(request: NimbusRequest, ad: NimbusAd) {
        print("didCompleteNimbusRequest")
    }
    
    func didFailNimbusRequest(request: NimbusRequest, error: NimbusError) {
        print("didFailNimbusRequest: \(error.localizedDescription)")
    }
}

extension UnityViewController: AdControllerDelegate {
    
    func didReceiveNimbusEvent(controller: AdController, event: NimbusEvent) {
        print("Nimbus didReceiveNimbusEvent: \(event)")
    }
    
    func didReceiveNimbusError(controller: AdController, error: NimbusError) {
        print("Nimbus didReceiveNimbusError: \(error)")
    }
}
