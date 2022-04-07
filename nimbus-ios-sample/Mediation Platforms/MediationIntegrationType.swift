//
//  MediationIntegrationType.swift
//  nimbus-ios-sample
//
//  Created by Inder Dhir on 1/13/22.
//

enum MediationIntegrationType: String, DemoItem {
    case google
    
    var description: String {
        rawValue.firstUppercased
    }
}
