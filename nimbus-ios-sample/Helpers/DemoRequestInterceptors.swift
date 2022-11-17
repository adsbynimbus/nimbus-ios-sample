//
//  DemoRequestInterceptors.swift
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

final class DemoRequestInterceptors {

    private(set) var aps: NimbusAPSRequestInterceptor?
    #if canImport(NimbusRequestFANKit) && canImport(NimbusSDK)
    private(set) var fan: NimbusFANRequestInterceptor?
    #endif
    //private(set) var unity: NimbusUnityRequestInterceptor?

    static var shared = DemoRequestInterceptors()
    
    private init() {
        if let apsAppKey = ConfigManager.shared.apsAppKey, !apsAppKey.isEmpty {
            aps = NimbusAPSRequestInterceptor(appKey: apsAppKey, adSizes: [])
        }
        
        #if canImport(NimbusRequestFANKit) && canImport(NimbusSDK)
        if let facebookAppId =
            ConfigManager.shared.fbNativePlacementId?.components(separatedBy: "_").first,
           !facebookAppId.isEmpty {
            fan = NimbusFANRequestInterceptor(appId: facebookAppId)
            fan?.forceTestAd = true
        }
        #endif
        
        /*
        if let unityGameId =
            ConfigManager.shared.unityGameId, !unityGameId.isEmpty {
            unity = NimbusUnityRequestInterceptor(gameId: unityGameId)
        } */
    }
}
