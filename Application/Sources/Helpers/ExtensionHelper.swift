//
//  ExtensionHelper.swift
//  Nimbus
//  Created on 4/22/25
//  Copyright © 2025 Nimbus Advertising Solutions Inc. All rights reserved.
//

import Nimbus
import Foundation

/// This helper is here only for the purposes of the sample app where we need to disable
/// certain extensions to make sure an AdMob test case always shows an AdMob ad for instance,
/// it's not something a client app would normally do.
struct ExtensionHelper {
    static var enabledState: [ObjectIdentifier: Bool] {
        Nimbus.shared.extensions.mapValues { $0.enabled }
    }
    
    static func disableAllExtensions(except: NimbusExtension.Type? = nil) {
        Task { @MainActor in
            for (key, ext) in Nimbus.shared.extensions {
                if except == nil || key != ObjectIdentifier(except!) {
                    type(of: ext).disable()
                }
            }
        }
    }
    
    static func restoreExtensionsState(from: [ObjectIdentifier: Bool]) {
        Task { @MainActor in
            for (extType, enabled) in from {
                guard let ext = Nimbus.shared.extensions[extType] else {
                    continue
                }
                
                if enabled && !ext.enabled { type(of: ext).enable() }
                else if !enabled && ext.enabled { type(of: ext).disable() }
            }
        }
    }
}
