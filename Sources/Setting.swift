//
//  Setting.swift
//  nimbus-ios-sample
//
//  Created by Victor Takai on 10/11/21.
//

import DTBiOSSDK
import NimbusKit

enum Setting: String, CaseIterable {
    case nimbusTestMode          = "Nimbus Test Mode"
    case coppaOn                 = "Set COPPA On"
    case forceNoFill             = "Force No Fill"
    case omThirdPartyViewability = "Send OMID Viewability Flag"
    case tradeDesk               = "Send Trade Desk Identity"
    case gdprConsent             = "GDPR Consent"
    case ccpaConsent             = "CCPA Consent"
    case gppConsent              = "GPP Consent"
    
    var isEnabled: Bool {
        switch self {
        case .nimbusTestMode:
            return UserDefaults.standard.nimbusTestMode
        case .coppaOn:
            return UserDefaults.standard.coppaOn
        case .forceNoFill:
            return UserDefaults.standard.forceNoFill
        case .omThirdPartyViewability:
            return UserDefaults.standard.omThirdPartyViewability
        case .tradeDesk:
            return UserDefaults.standard.tradeDesk
        case .gdprConsent:
            return UserDefaults.standard.gdprConsent
        case .ccpaConsent:
            return UserDefaults.standard.ccpaConsent
        case .gppConsent:
            return UserDefaults.standard.gppConsent
        }
    }
    
    func update(isEnabled: Bool) {
        switch self {
        case .nimbusTestMode:
            UserDefaults.standard.nimbusTestMode = isEnabled
            DTBAds.sharedInstance().testMode = isEnabled
        case .coppaOn:
            UserDefaults.standard.coppaOn = isEnabled
        case .forceNoFill:
            UserDefaults.standard.forceNoFill = isEnabled
        case .omThirdPartyViewability:
            UserDefaults.standard.omThirdPartyViewability = isEnabled
        case .tradeDesk:
            UserDefaults.standard.tradeDesk = isEnabled
        case .gdprConsent:
            UserDefaults.standard.gdprConsent = isEnabled
        case .ccpaConsent:
            UserDefaults.standard.ccpaConsent = isEnabled
        case .gppConsent:
            UserDefaults.standard.gppConsent = isEnabled
        }
    }
}


// Nimbus Test Mode
extension UserDefaults {
    var nimbusTestMode: Bool {
        get {
            register(defaults: [#function: true])
            return bool(forKey: #function)
        }
        set {
            set(newValue, forKey: #function)
            Nimbus.shared.testMode = newValue
        }
    }
    
    var omThirdPartyViewability: Bool {
        get {
            register(defaults: [#function: true])
            return bool(forKey: #function)
        }
        set {
            set(newValue, forKey: #function)
            Nimbus.shared.isThirdPartyViewabilityEnabled = newValue
        }
    }
    
    var coppaOn: Bool {
        get {
            register(defaults: [#function: false])
            return bool(forKey: #function)
        }
        set {
            set(newValue, forKey: #function)
            Nimbus.shared.coppa = newValue
        }
    }
    
    var gdprConsent: Bool {
        get {
            register(defaults: [#function: false])
            return bool(forKey: #function)
        }
        set {
            set(newValue, forKey: #function)
            if newValue, var user = NimbusAdManager.user {
                // Same string as Android sample app
                user.configureGdprConsent(consentString: testGDPRConsentString)
                NimbusAdManager.user = user
            } else {
                NimbusAdManager.user?.extensions?.removeValue(forKey: "consent")
            }
        }
    }
    
    var ccpaConsent: Bool {
        get {
            register(defaults: [#function: false])
            return bool(forKey: #function)
        }
        set {
            set(newValue, forKey: #function)
            if newValue {
                UserDefaults.standard.set("1NYN", forKey: "IABUSPrivacy_String")
            } else {
                UserDefaults.standard.removeObject(forKey: "IABUSPrivacy_String")
            }
        }
    }
    
    var gppConsent: Bool {
        get {
            register(defaults: [#function: false])
            return bool(forKey: #function)
        }
        set {
            set(newValue, forKey: #function)
            if newValue {
                UserDefaults.standard.set(testGppConsentString, forKey: "IABGPP_HDR_GppString")
                UserDefaults.standard.set(testGppSectionId, forKey: "IABGPP_GppSID")
            } else {
                UserDefaults.standard.removeObject(forKey: "IABGPP_HDR_GppString")
                UserDefaults.standard.removeObject(forKey: "IABGPP_GppSID")
            }
        }
    }
    
    var tradeDesk: Bool {
        get {
            register(defaults: [#function: false])
            return bool(forKey: #function)
        }
        set {
            set(newValue, forKey: #function)
            if newValue && nimbusTestMode && NimbusAdManager.extendedIds?.first(where: { $0.source == "tradedesk.com" }) == nil {
                var extendedIds = NimbusAdManager.extendedIds ?? []
                extendedIds.insert(NimbusExtendedId(source: "tradedesk.com", id: "TestUID2Token"))
                NimbusAdManager.extendedIds = extendedIds
            } else {
                if let extendedId = NimbusAdManager.extendedIds?.first(where: { $0.source == "tradedesk.com" }) {
                    NimbusAdManager.extendedIds?.remove(extendedId)
                }
            }
        }
    }
    
    var forceNoFill: Bool {
        get {
            register(defaults: [#function: false])
            return bool(forKey: #function)
        }
        set {
            set(newValue, forKey: #function)
            var headers = NimbusAdManager.additionalRequestHeaders ?? [:]
            headers["Nimbus-Test-No-Fill"] = String(newValue)
            NimbusAdManager.additionalRequestHeaders = headers
        }
    }
}

// MARK: Test Data

fileprivate let testGDPRConsentString = "CLcVDxRMWfGmWAVAHCENAXCkAKDAADnAABRgA5mdfCKZuYJez-NQm0TBMYA4oCAAGQYIAAAAAAEAIAEgAA.argAC0gAAAAAAAAAAAA"
fileprivate let testGppConsentString = "DBABMA~CLcVDxRMWfGmWAVAHCENAXCkAKDAADnAABRgA5mdfCKZuYJez-NQm0TBMYA4oCAAGQYIAAAAAAEAIAEgAA.argAC0gAAAAAAAAAAAA"
fileprivate let testGppSectionId = "2"
