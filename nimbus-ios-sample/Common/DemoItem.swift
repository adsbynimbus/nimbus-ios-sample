//
//  ListItem.swift
//  nimbus-ios-sample
//
//  Created by Victor Takai on 18/11/21.
//

import Foundation

protocol DemoItem: CaseIterable, CustomStringConvertible { }

extension RawRepresentable where RawValue == String, Self: DemoItem {
    var description: String {
        rawValue.camelCaseToWords()
    }
}
