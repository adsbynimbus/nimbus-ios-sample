//
//  UIImage+Extension.swift
//  nimbus-ios-sample
//
//  Created by Victor Takai on 22/11/21.
//

import UIKit

extension UIImage {
    func imageWithInset(inset: CGFloat) -> UIImage {
        imageWithInsets(
            insets: UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        )
    }
    
    func imageWithInsets(insets: UIEdgeInsets) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(
            CGSize(
                width: size.width + insets.left + insets.right,
                height: size.height + insets.top + insets.bottom
            ), false,
            scale
        )
        let origin = CGPoint(x: insets.left, y: insets.top)
        draw(at: origin)
        let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imageWithInsets!
    }
}
