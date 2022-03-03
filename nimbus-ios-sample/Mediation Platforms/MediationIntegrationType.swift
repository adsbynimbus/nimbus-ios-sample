//
//  MediationIntegrationType.swift
//  nimbus-ios-sample
//
//  Created by Inder Dhir on 1/13/22.
//

enum MediationIntegrationType: String, DemoItem {
    case google, moPub
    
    var description: String {
        switch self {
        case .google:
            return "Google"
        case .moPub:
            return "MoPub"
        }
    }
}
