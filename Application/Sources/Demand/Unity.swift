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

final class UnityViewController: SampleAdViewController {

    private let adType: UnitySample
    private var adManager: NimbusAdManager?
    
    init(adType: UnitySample, headerSubTitle: String) {
        self.adType = adType
        super.init(headerTitle: adType.rawValue, headerSubTitle: headerSubTitle, enabledExtension: UnityExtension.self)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        controller.register(delegate: self)
        nimbusAd = ad
    }
    
    func didCompleteNimbusRequest(request: NimbusRequest, ad: NimbusAd) {
        print("didCompleteNimbusRequest")
    }
    
    func didFailNimbusRequest(request: NimbusRequest, error: NimbusError) {
        print("didFailNimbusRequest: \(error.localizedDescription)")
    }
}
