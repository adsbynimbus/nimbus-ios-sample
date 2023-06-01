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

extension UIApplicationDelegate {
    func setupUnityDemand() {
        if !unityGameId.isEmpty {
            Nimbus.shared.renderers[.forNetwork("unity")] = NimbusUnityAdRenderer()
            NimbusRequestManager.requestInterceptors?.append(NimbusUnityRequestInterceptor(gameId: unityGameId))
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
    
    deinit {
        adController?.destroy()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        guard !unityGameId.isEmpty else {
            showCustomAlert("unity_game_id")
            return
        }

        setupAdRendering()
    }

    private func setupAdRendering() {
        adManager = NimbusAdManager()
        adManager?.delegate = self
        
        switch adType {
        case .unityRewardedVideo:
            adManager?.showRewardedAd(
                request: NimbusRequest.forRewardedVideo(position: adType.description),
                adPresentingViewController: self
            )
        }
    }
}

extension UnityViewController: NimbusAdManagerDelegate {
  
    func didRenderAd(request: NimbusRequest, ad: NimbusAd, controller: AdController) {
        print("didRenderAd")
        
        adController = controller
        adController?.delegate = self
        nimbusAd = ad
    }
    
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
