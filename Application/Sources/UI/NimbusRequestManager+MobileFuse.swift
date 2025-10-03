//
//  NimbusRequestManager+MobileFuse.swift
//  NimbusInternalSampleApp
//
//  Created on 9/13/23.
//  Copyright © 2023 Nimbus Advertising Solutions Inc. All rights reserved.
//

import NimbusKit

private let enableMobileFuseHeaderKey = "Nimbus-Test-EnableMobileFuseSDK"

///  Nimbus test endpoint header manipulation. This is NOT something to do in production environment.
@MainActor
extension NimbusRequestManager {
    static func insertMobileFuseHeader() {
        NimbusRequestManager.additionalRequestHeaders[enableMobileFuseHeaderKey] = "true"
    }
    
    static func removeMobileFuseHeader() {
        NimbusRequestManager.additionalRequestHeaders.removeValue(forKey: enableMobileFuseHeaderKey)
    }
}
