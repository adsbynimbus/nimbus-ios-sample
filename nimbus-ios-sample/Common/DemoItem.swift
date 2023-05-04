//
//  ListItem.swift
//  nimbus-ios-sample
//
//  Created by Victor Takai on 18/11/21.
//

import Foundation

enum IdentifierType {
    case cell, cellLabel, cellSwitch, header, headerLabel
}

protocol Identifier {
    func getIdentifier(prefix: String, _ identifierType: IdentifierType) -> String
}

protocol DemoItem: CaseIterable, CustomStringConvertible, Identifier {}

extension RawRepresentable where RawValue == String, Self: DemoItem {
    var description: String {
        rawValue.camelCaseToWords()
    }
    
    func getIdentifier(prefix: String = "", _ identifierType: IdentifierType) -> String {
        var identifier = prefix + rawValue.firstUppercased
        switch identifierType {
        case .cell:
            identifier += "Cell"
        case .cellLabel:
            identifier += "CellLabel"
        case .cellSwitch:
            identifier += "CellSwitch"
        case .header:
            identifier += "Header"
        case .headerLabel:
            identifier += "HeaderLabel"
        }
        return identifier
    }
}
