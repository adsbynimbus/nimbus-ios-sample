//
//  String+Extension.swift
//  nimbus-ios-sample
//
//  Created by Victor Takai on 11/11/21.
//

import Foundation

extension String {
    func camelCaseToWords() -> String {
        unicodeScalars.reduce("") {
            if CharacterSet.uppercaseLetters.contains($1) {
                return ($0.capitalized + " " + String($1))
            } else {
                return $0.capitalized + String($1)
            }
        }
    }
}
