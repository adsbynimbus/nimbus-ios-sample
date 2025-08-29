//
//  UnityViewController.swift
//  nimbus-ios-sample
//
//  Created on 02/05/23.
//

import NimbusKit
import NimbusCoreKit
#if canImport(NimbusSDK) // CocoaPods
import NimbusSDK
#else                    // Swift Package Manager
import NimbusUnityKit
#endif
import UIKit

final class UnityViewController: SampleAdViewController {

    private let adType: UnitySample
    private var rewardedAd: RewardedAd?
    
    init(adType: UnitySample, headerSubTitle: String) {
        self.adType = adType
        super.init(headerTitle: adType.rawValue, headerSubTitle: headerSubTitle, enabledExtension: UnityExtension.self)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch adType {
        case .unityRewardedVideo:
            Task { await showAd() }
        }
    }
    
    func showAd() async {
        do {
            rewardedAd = try await Nimbus.rewardedAd(position: adType.description).show(in: self)
        } catch {
            print("Failed to show ad: \(error)")
        }
    }
}
