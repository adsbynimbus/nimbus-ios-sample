//
//  DemoRequestInterceptors.swift
//  nimbus-ios-sample
//
//  Created by Victor Takai on 24/01/22.
//

import NimbusSDK
import NimbusRequestAPSKit

final class DemoRequestInterceptors {

    private(set) var aps: NimbusAPSRequestInterceptor?
    private(set) var fan: NimbusFANRequestInterceptor?
    private(set) var unity: NimbusUnityRequestInterceptor?
    private(set) var vungle: NimbusVungleRequestInterceptor?

    static var shared = DemoRequestInterceptors()
    
    private init() {
        if let apsAppKey = ConfigManager.shared.apsAppKey, !apsAppKey.isEmpty {
            aps = NimbusAPSRequestInterceptor(appKey: apsAppKey, adSizes: [])
        }
        
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
        
        if let vungleAppId =
            ConfigManager.shared.vungleAppId, !vungleAppId.isEmpty {
            vungle = NimbusVungleRequestInterceptor(appId: vungleAppId)
        }
    }
}
