//
//  UnityViewController.swift
//  nimbus-ios-sample
//
//  Created by Victor Takai on 02/05/23.
//

import NimbusKit
#if canImport(NimbusSDK) // CocoaPods
import NimbusSDK
#else                    // Swift Package Manager
import NimbusUnityKit
#endif
import UIKit

fileprivate let unityGameId = Bundle.main.infoDictionary?["Unity Game ID"] as? String ?? ""

extension AppDelegate {
    func setupUnityDemand() {
        if !unityGameId.isEmpty {
            NimbusRequestManager.requestInterceptors?.append(NimbusUnityRequestInterceptor(gameId: unityGameId))
            Nimbus.shared.renderers[.forNetwork("unity")] = NimbusUnityAdRenderer()
        }
    }
}

final class UnityViewController: DemoViewController {

    private let adType: UnitySample
    private var adManager: NimbusAdManager?
    private var adController: AdController?
    private var nimbusAd: NimbusAd?

    init(adType: UnitySample, headerSubTitle: String) {
        self.adType = adType
        
        super.init(headerTitle: adType.description, headerSubTitle: headerSubTitle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        if !unityGameId.isEmpty {
            showCustomAlert("unity_game_id")
        } else {
            setupAdRendering()
        }
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
        adController?.delegate = self
        nimbusAd = ad
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
        if let ad = nimbusAd, event == .loaded {
            controller.adView?.setUiTestIdentifiers(for: ad)
        }
    }
    
    func didReceiveNimbusError(controller: AdController, error: NimbusError) {
        print("Nimbus didReceiveNimbusError: \(error)")
    }
}
