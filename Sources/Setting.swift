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
    
    func getPrefs() -> Bool {
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
    
    func updatePrefs(_ isOn: Bool) {
        switch self {
        case .nimbusTestMode:
            UserDefaults.standard.nimbusTestMode = isOn
            DTBAds.sharedInstance().testMode = isOn
        case .coppaOn:
            UserDefaults.standard.coppaOn = isOn
        case .forceNoFill:
            UserDefaults.standard.forceNoFill = isOn
        case .omThirdPartyViewability:
            UserDefaults.standard.omThirdPartyViewability = isOn
        case .tradeDesk:
            UserDefaults.standard.tradeDesk = isOn
            
        case .gdprConsent:
            UserDefaults.standard.gdprConsent = isOn
        case .ccpaConsent:
            UserDefaults.standard.ccpaConsent = isOn
        case .gppConsent:
            UserDefaults.standard.gppConsent = isOn
        }
    }
    
    var isUserPrivacySetting: Bool {
        switch self {
        case .gdprConsent, .ccpaConsent, .gppConsent:
            return true
        default:
            return false
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
}

// Set COOPA On
extension UserDefaults {
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
}

// GDPR Consent
extension UserDefaults {
    var gdprConsent: Bool {
        get {
            register(defaults: [#function: false])
            return bool(forKey: #function)
        }
        set {
            set(newValue, forKey: #function)
            if newValue, var user = NimbusAdManager.user {
                // Same string as Android sample app
                user.configureGdprConsent(consentString: "CLcVDxRMWfGmWAVAHCENAXCkAKDAADnAABRgA5mdfCKZuYJez-NQm0TBMYA4oCAAGQYIAAAAAAEAIAEgAA.argAC0gAAAAAAAAAAAA")
                NimbusAdManager.user = user
            } else {
                NimbusAdManager.user?.extensions?.removeValue(forKey: "consent")
            }
        }
    }
}

// CCPA Consent
let usPrivacyStringKey = "IABUSPrivacy_String"
extension UserDefaults {
    var ccpaConsent: Bool {
        get {
            register(defaults: [#function: false])
            return bool(forKey: #function)
        }
        set {
            set(newValue, forKey: #function)
            if newValue {
                UserDefaults.standard.set("1NYN", forKey: usPrivacyStringKey)
            } else {
                UserDefaults.standard.removeObject(forKey: usPrivacyStringKey)
            }
        }
    }
}

// GPP Consent
private let gppConsentStringKey = "IABGPP_HDR_GppString"
private let gppSectionIdKey = "IABGPP_GppSID"
private let testGppConsentString = "DBABMA~CLcVDxRMWfGmWAVAHCENAXCkAKDAADnAABRgA5mdfCKZuYJez-NQm0TBMYA4oCAAGQYIAAAAAAEAIAEgAA.argAC0gAAAAAAAAAAAA"
private let testGppSectionId = "2"

extension UserDefaults {
    var gppConsent: Bool {
        get {
            register(defaults: [#function: false])
            return bool(forKey: #function)
        }
        set {
            set(newValue, forKey: #function)
            if newValue {
                UserDefaults.standard.set(testGppConsentString, forKey: gppConsentStringKey)
                UserDefaults.standard.set(testGppSectionId, forKey: gppSectionIdKey)
            } else {
                UserDefaults.standard.removeObject(forKey: gppConsentStringKey)
                UserDefaults.standard.removeObject(forKey: gppSectionIdKey)
            }
        }
    }
}


// Force Ad Request Error
extension UserDefaults {
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

// Send OMID Viewability Flag
extension UserDefaults {
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
}

// Trade Desk
extension UserDefaults {
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
}