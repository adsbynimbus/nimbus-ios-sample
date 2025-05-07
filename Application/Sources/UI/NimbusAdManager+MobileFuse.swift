//
//  NimbusAdManager+MobileFuse.swift
//  NimbusInternalSampleApp
//
//  Created on 9/13/23.
//  Copyright © 2023 Nimbus Advertising Solutions Inc. All rights reserved.
//

import NimbusKit

private let enableMobileFuseHeaderKey = "Nimbus-Test-EnableMobileFuseSDK"

///  Nimbus test endpoint header manipulation. This is NOT something to do in production environment.
extension NimbusAdManager {
    nonisolated static func insertMobileFuseHeader() {
        if NimbusAdManager.additionalRequestHeaders == nil {
            NimbusAdManager.additionalRequestHeaders = [:]
        }
        
        NimbusAdManager.additionalRequestHeaders?[enableMobileFuseHeaderKey] = "true"
    }
    
    nonisolated static func removeMobileFuseHeader() {
        NimbusAdManager.additionalRequestHeaders?.removeValue(forKey: enableMobileFuseHeaderKey)
    }
}
