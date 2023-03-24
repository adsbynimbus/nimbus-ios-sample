//
//  DemoRequestInterceptors.swift
//  nimbus-ios-sample
//
//  Created by Victor Takai on 24/01/22.
//

import UnityAds

#if canImport(NimbusSDK)
import NimbusSDK
#endif

#if canImport(NimbusRequestFANKit)
import NimbusRequestFANKit
#endif

#if canImport(NimbusFANKit)
import NimbusFANKit
#endif

#if canImport(NimbusUnityKit)
import NimbusUnityKit
#endif

final class DemoRequestInterceptors {
    private(set) var fan: NimbusFANRequestInterceptor?
    private(set) var unity: NimbusUnityRequestInterceptor?

    static var shared = DemoRequestInterceptors()
    
    private init() {
        if let facebookAppId =
            ConfigManager.shared.fbNativePlacementId?.components(separatedBy: "_").first,
           !facebookAppId.isEmpty {
            fan = NimbusFANRequestInterceptor(appId: facebookAppId)
            fan?.forceTestAd = true
        }
        
        if let unityGameId =
            ConfigManager.shared.unityGameId, !unityGameId.isEmpty {
            unity = NimbusUnityRequestInterceptor(gameId: unityGameId)
        }
    }
}
