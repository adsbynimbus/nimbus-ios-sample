//
//  Settings.swift
//  nimbus-ios-sample
//
//  Created on 10/11/21.
//

import DTBiOSSDK
import NimbusKit

@MainActor
protocol SettingsEnum {
    static var allCases: [Self] { get }
    
    var rawValue: String { get }
    var isEnabled: Bool { get }
    
    func update(isEnabled: Bool)
}

enum UserDetailsSettings: String, SettingsEnum, CaseIterable {
    case gdprConsent             = "GDPR Consent"
    case ccpaConsent             = "CCPA Consent"
    case gppConsent              = "GPP Consent"
    
    var isEnabled: Bool {
        switch self {
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
        case .gdprConsent:
            UserDefaults.standard.gdprConsent = isEnabled
        case .ccpaConsent:
            UserDefaults.standard.ccpaConsent = isEnabled
        case .gppConsent:
            UserDefaults.standard.gppConsent = isEnabled
        }
    }
}

enum GeneralSettings: String, SettingsEnum, CaseIterable {
    case nimbusTestMode          = "Nimbus Test Mode"
    case coppaOn                 = "Set COPPA On"
    case forceNoFill             = "Force No Fill"
    case tradeDesk               = "Send Trade Desk Identity"
    case eventLogHidden          = "Hide Event Log By Default"
    
    var isEnabled: Bool {
        switch self {
        case .nimbusTestMode:
            return UserDefaults.standard.nimbusTestMode
        case .coppaOn:
            return UserDefaults.standard.coppaOn
        case .forceNoFill:
            return UserDefaults.standard.forceNoFill
        case .tradeDesk:
            return UserDefaults.standard.tradeDesk
        case .eventLogHidden:
            return UserDefaults.standard.eventLogHiddenByDefault
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
        case .tradeDesk:
            UserDefaults.standard.tradeDesk = isEnabled
        case .eventLogHidden:
            UserDefaults.standard.eventLogHiddenByDefault = isEnabled
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
    
    @MainActor
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
                UserDefaults.IAB.usPrivacyString = "1NYN"
            } else {
                UserDefaults.IAB.usPrivacyString = nil
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
                UserDefaults.IAB.gppConsentString = testGppConsentString
                UserDefaults.IAB.gppSectionId = testGppSectionId
            } else {
                UserDefaults.IAB.gppConsentString = nil
                UserDefaults.IAB.gppSectionId = nil
            }
        }
    }
    
    @MainActor
    var tradeDesk: Bool {
        get {
            register(defaults: [#function: false])
            return bool(forKey: #function)
        }
        set {
            set(newValue, forKey: #function)
            if newValue && nimbusTestMode && NimbusAdManager.extendedIds?.first(where: { $0.source == "tradedesk.com" }) == nil {
                var extendedIds = NimbusAdManager.extendedIds ?? []
                extendedIds.insert(NimbusExtendedId(source: "tradedesk.com", uids: [.init(id: "TestUID2Token")]))
                NimbusAdManager.extendedIds = extendedIds
            } else {
                if let extendedId = NimbusAdManager.extendedIds?.first(where: { $0.source == "tradedesk.com" }) {
                    NimbusAdManager.extendedIds?.remove(extendedId)
                }
            }
        }
    }
    
    @MainActor
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
    
    var eventLogHiddenByDefault: Bool {
        get {
            register(defaults: [#function: true])
            return bool(forKey: #function)
        }
        set {
            set(newValue, forKey: #function)
        }
    }
}

// MARK: Test Data

fileprivate let testGDPRConsentString = "CLcVDxRMWfGmWAVAHCENAXCkAKDAADnAABRgA5mdfCKZuYJez-NQm0TBMYA4oCAAGQYIAAAAAAEAIAEgAA.argAC0gAAAAAAAAAAAA"
fileprivate let testGppConsentString = "DBABMA~CLcVDxRMWfGmWAVAHCENAXCkAKDAADnAABRgA5mdfCKZuYJez-NQm0TBMYA4oCAAGQYIAAAAAAEAIAEgAA.argAC0gAAAAAAAAAAAA"
fileprivate let testGppSectionId = "2"
