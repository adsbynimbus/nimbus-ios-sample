//
//  SweepingInterceptor.swift
//  NimbusInternalSampleApp
//  Created on 9/11/24
//  Copyright © 2024 Nimbus Advertising Solutions Inc. All rights reserved.
//

import Foundation
import NimbusKit

/// This interceptor makes sure there's not multiple colliding third party demand networks at play solely
/// for the purpose of the sample app's dedicated use cases. For instance, we want to prevent AdMob Banner
/// controller accidentally presenting a Vungle ad. This helper serves for internal purposes of the sample app
/// and should not be considered for a pub integration.
class SweepingInterceptor: NimbusRequestInterceptor {
    let keep: ThirdPartyDemandNetwork
    
    init(keep: ThirdPartyDemandNetwork) {
        self.keep = keep
    }
    
    func modifyRequest(request: NimbusRequest) {
        if keep != .admob { request.user?.extensions?.removeValue(forKey: "admob_gde_signals") }
        if keep != .unity { request.user?.extensions?.removeValue(forKey: "unity_buyeruid") }
        if keep != .mobileFuse { request.user?.extensions?.removeValue(forKey: "mfx_buyerdata") }
        if keep != .vungle { request.user?.extensions?.removeValue(forKey: "vungle_buyeruid") }
        if keep != .moloco { request.user?.extensions?.removeValue(forKey: "moloco_buyeruid") }
        if keep != .facebook {
            request.user?.extensions?.removeValue(forKey: "facebook_buyeruid")
            request.impressions[0].extensions?.removeValue(forKey: "facebook_app_id")
        }
    }
    
    func didCompleteNimbusRequest(with ad: NimbusAd) {}
    func didFailNimbusRequest(with error: NimbusError) {}
}
