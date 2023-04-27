//
//  ThirdPartyDemandIntegrationType.swift
//  nimbus-ios-sample
//
//  Created by Bruno Bruggemann on 20/04/23.
//

enum ThirdPartyDemandIntegrationType: String, DemoItem {
    case aps
    case fan
    case unity
    case vungle
    
    var description: String {
        switch
        rawValue.uppercased()
    }
}
