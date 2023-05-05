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

#if canImport(NimbusVungleKit)
import NimbusVungleKit
#endif

#if canImport(NimbusUnityKit)
import NimbusUnityKit
#endif

#if canImport(NimbusLiveRampKit)
import NimbusLiveRampKit
#endif


final class DemoRequestInterceptors {
    private(set) var fan: NimbusFANRequestInterceptor?
    private(set) var vungle: NimbusVungleRequestInterceptor?
    private(set) var unity: NimbusUnityRequestInterceptor?

    static var shared = DemoRequestInterceptors()
    
    private init() {
        if let facebookAppId =
            ConfigManager.shared.fbNativePlacementId?.components(separatedBy: "_").first,
           !facebookAppId.isEmpty {
            fan = NimbusFANRequestInterceptor(appId: facebookAppId)
            fan?.forceTestAd = true
        }
        
        if let vungleAppId = ConfigManager.shared.vungleAppId, !vungleAppId.isEmpty {
            vungle = NimbusVungleRequestInterceptor(appId: vungleAppId, isLoggingEnabled: true)
        }
        
        if let unityGameId =
            ConfigManager.shared.unityGameId, !unityGameId.isEmpty {
            unity = NimbusUnityRequestInterceptor(gameId: unityGameId)
        }
    }
    
    func setFANRequestInterceptor() {
        removeRequestInterceptors()
        
        let interceptors = NimbusAdManager.requestInterceptors ?? []
        if let fan, !interceptors.contains(where: { $0 is NimbusFANRequestInterceptor }) {
            NimbusAdManager.requestInterceptors?.append(fan)
        }
    }
    
    func setVungleRequestInterceptor() {
        removeRequestInterceptors()
        
        let interceptors = NimbusAdManager.requestInterceptors ?? []
        if let vungle, !interceptors.contains(where: { $0 is NimbusVungleRequestInterceptor }) {
            NimbusAdManager.requestInterceptors?.append(vungle)
        }
    }
    
    func setUnityRequestInterceptor() {
        removeRequestInterceptors()
        
        let interceptors = NimbusAdManager.requestInterceptors ?? []
        if let unity, !interceptors.contains(where: { $0 is NimbusUnityRequestInterceptor }) {
            NimbusAdManager.requestInterceptors?.append(unity)
        }
    }
    
    func removeRequestInterceptors() {
        // It MUST not remove LiveRampInterceptor
        NimbusAdManager.requestInterceptors?.removeAll(where: {
            !($0 is NimbusLiveRampInterceptor)
        })
    }
}
