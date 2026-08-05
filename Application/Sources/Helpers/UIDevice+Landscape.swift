//
//  UIDevice+Landscape.swift
//  Nimbus
//  Created on 8/5/26
//  Copyright © 2026 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit

public extension UIDevice {
    static var isLandscape: Bool {
        let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
        return (scenes.first { $0.activationState == .foregroundActive }
            ?? scenes.first { $0.activationState == .foregroundInactive }
            ?? scenes.first)?.interfaceOrientation.isLandscape ?? false
    }
}
