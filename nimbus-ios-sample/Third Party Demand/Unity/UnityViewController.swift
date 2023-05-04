//
//  UnityViewController.swift
//  nimbus-ios-sample
//
//  Created by Victor Takai on 02/05/23.
//

import UIKit
import NimbusKit

#if canImport(NimbusLiveRampKit)
import NimbusLiveRampKit
#endif

#if canImport(NimbusUnityKit)
import NimbusUnityKit
#endif

final class UnityViewController: DemoViewController {

    private let adType: ThirdPartyDemandAdType
    private var adManager: NimbusAdManager?
    
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
        
        // Remove unity demand provider. It MUST not remove LiveRampInterceptor
        NimbusAdManager.requestInterceptors?.removeAll(where: {
            $0 is NimbusUnityRequestInterceptor
        })
    }

    private func setupRequestInterceptor() {
        // Remove other demand providers. It MUST not remove LiveRampInterceptor
        NimbusAdManager.requestInterceptors?.removeAll(where: {
            !($0 is NimbusLiveRampInterceptor)
        })
        
        if let unity = DemoRequestInterceptors.shared.unity {
            NimbusAdManager.requestInterceptors?.append(unity)
        }
    }
    
    private func setupAdRendering() {
        guard adType == .unityRewardedVideo else {
            return
        }
        
        adManager = NimbusAdManager()
        adManager?.delegate = self
        adManager?.showRewardedAd(
            request: NimbusRequest.forVideoAd(position: "Rewarded_iOS"),
            adPresentingViewController: self
        )
    }
}

// MARK: NimbusAdManagerDelegate

extension UnityViewController: NimbusAdManagerDelegate {
  
    func didRenderAd(request: NimbusRequest, ad: NimbusAd, controller: AdController) {
        print("didRenderAd")
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
