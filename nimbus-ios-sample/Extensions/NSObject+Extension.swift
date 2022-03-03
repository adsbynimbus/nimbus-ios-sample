//
//  NSObject+Extension.swift
//  nimbus-ios-sample
//
//  Created by Victor Takai on 15/11/21.
//

import Foundation

extension NSObject {
    class var nameOfClass: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}
