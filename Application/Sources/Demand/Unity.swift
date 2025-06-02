//
//  UnityViewController.swift
//  nimbus-ios-sample
//
//  Created on 02/05/23.
//

import NimbusKit
#if canImport(NimbusSDK) // CocoaPods
import NimbusSDK
#else                    // Swift Package Manager
import NimbusUnityKit
#endif
import UIKit

let unityGameId = Bundle.main.infoDictionary?["Unity Game ID"] as? String ?? ""

extension UIApplicationDelegate {
    func setupUnityDemand() {
        if !unityGameId.isEmpty {
            Nimbus.shared.renderers[.forNetwork("unity")] = NimbusUnityAdRenderer()
            NimbusRequestManager.requestInterceptors?.append(NimbusUnityRequestInterceptor(gameId: unityGameId))
        }
    }
}

final class UnityViewController: SampleAdViewController {

    private let adType: UnitySample
    private var adManager: NimbusRequestManager?
    private var adController: AdController?
    private var nimbusAdView: NimbusAdView!
    private var rewardedViewController: NimbusAdViewController!

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
        
        guard !unityGameId.isEmpty else {
            showCustomAlert("unity_game_id")
            return
        }

        setupAdRendering()
    }

    private func setupAdRendering() {
        adManager = NimbusRequestManager()
        adManager?.delegate = self
        
        switch adType {
        case .unityRewardedVideo:
            adManager?.performRequest(
                request: NimbusRequest.forRewardedVideo(position: adType.description)
            )
        }
    }
}

extension UnityViewController: NimbusAdManagerDelegate {

    func didRenderAd(request: NimbusRequest, ad: NimbusAd, controller: AdController) {
        print("didRenderAd")
    }
    
    func didCompleteNimbusRequest(request: NimbusRequest, ad: NimbusAd) {
        print("didCompleteNimbusRequest")
        nimbusAdView = NimbusAdView(adPresentingViewController: self)

        rewardedViewController = NimbusAdViewController(adView: nimbusAdView, ad: ad, companionAd: nil, closeButtonDelay: 5)
        rewardedViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        rewardedViewController.delegate = self

        nimbusAdView.adPresentingViewController = rewardedViewController
        nimbusAdView.delegate = self
        nimbusAdView.volume = 100

        present(rewardedViewController, animated: true, completion: nil)
        rewardedViewController.renderAndStart()
    }
    
    func didFailNimbusRequest(request: NimbusRequest, error: NimbusError) {
        print("didFailNimbusRequest: \(error.localizedDescription)")
    }
}
