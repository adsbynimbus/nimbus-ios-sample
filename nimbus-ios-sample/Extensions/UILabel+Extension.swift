//
//  UILabel+Extension.swift
//  nimbus-ios-sample
//
//  Created by Victor Takai on 09/11/21.
//

import UIKit

extension UILabel {
    func setTextSpacingBy(value: Double) {
        if let textString = self.text {
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(
                NSAttributedString.Key.kern,
                value: value,
                range: NSRange(location: 0, length: attributedString.length - 1)
            )
            attributedText = attributedString
        }
    }
}
