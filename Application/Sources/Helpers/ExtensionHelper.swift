//
//  ExtensionHelper.swift
//  Nimbus
//  Created on 4/22/25
//  Copyright © 2025 Nimbus Advertising Solutions Inc. All rights reserved.
//

import NimbusKit
import Foundation

/// This helper is here only for the purposes of the sample app where we need to disable
/// certain extensions to make sure an AdMob test case always shows an AdMob ad for instance,
/// it's not something a client app would normally do.
@MainActor
struct ExtensionHelper {
    static func enableAllExtensions() {
        setAllExtensions(enabled: true)
    }
    
    static func disableAllExtensions() {
        setAllExtensions(enabled: false)
    }
    
    static func setAllExtensions(enabled: Bool) {
        for (key, ext) in Nimbus.extensions {
            let t = type(of: ext)
            enabled ? t.enable() : t.disable()
        }
    }
}
