//
//  ThirdPartyDemandIntegrationType.swift
//  nimbus-ios-sample
//
//  Created by Bruno Bruggemann on 20/04/23.
//

enum ThirdPartyDemandIntegrationType: String, DemoItem {
    case aps
    case meta
    case unity
    case vungle
    
    var description: String {
        switch self {
        case .aps:
            return rawValue.uppercased()
        default:
            return rawValue.camelCaseToWords()
        }
    }
}
