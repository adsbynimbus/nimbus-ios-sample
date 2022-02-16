//
//  DemoDemandProviders.swift
//  nimbus-ios-sample
//
//  Created by Victor Takai on 24/01/22.
//

import UnityAds
import NimbusRequestAPSKit

#if canImport(NimbusRequestFANKit)
import NimbusRequestFANKit
#endif

#if canImport(NimbusUnityKit)
import NimbusUnityKit
#endif

#if canImport(NimbusSDK)
import NimbusSDK
#endif

class DemoDemandProviders {

    private(set) var aps: NimbusAPSDemandProvider?
    #if canImport(NimbusRequestFANKit) && canImport(NimbusSDK)
    private(set) var fan: NimbusFANDemandProvider?
    #endif
    private(set) var unity: NimbusUnityDemandProvider?

    static var shared: DemoDemandProviders = DemoDemandProviders()
    
    private init() {
        if let apsAppKey = ConfigManager.shared.apsAppKey, !apsAppKey.isEmpty {
            aps = NimbusAPSDemandProvider(appKey: apsAppKey, adSizes: [])
        }
        
        #if canImport(NimbusRequestFANKit) && canImport(NimbusSDK)
        if let facebookAppId =
            ConfigManager.shared.fbNativePlacementId?.components(separatedBy: "_").first,
           !facebookAppId.isEmpty {
            fan = NimbusFANDemandProvider(appId: facebookAppId)
            fan?.forceTestAd = true
        }
        #endif
        
        if let unityGameId =
            ConfigManager.shared.unityGameId, !unityGameId.isEmpty {
            unity = NimbusUnityDemandProvider(gameId: unityGameId)
        }
    }
}
