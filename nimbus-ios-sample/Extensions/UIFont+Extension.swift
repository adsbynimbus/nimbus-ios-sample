//
//  UIFont+Extension.swift
//  nimbus-ios-sample
//
//  Created by Victor Takai on 09/11/21.
//

import UIKit

enum ProximaNovaWeight: String {
    case bold, regular, semibold
}

extension UIFont {
    static func proximaNova(size: CGFloat, weight: ProximaNovaWeight = .regular) -> UIFont {
        let name = "ProximaNova-\(weight.rawValue.capitalized)"
        guard let font = UIFont(name: name, size: size) else {
            fatalError("Font '\(name)' not found")
        }
        return font
    }
}
