//
//  Setting.swift
//  nimbus-ios-sample
//
//  Created by Victor Takai on 10/11/21.
//

import NimbusKit

enum Setting: String, DemoItem {
    case nimbusTestMode
    case coppaOn
    case gdprConsent
    case forceNoFill
    case omThirdPartyViewability
    
    var description: String {
        switch self {
        case .nimbusTestMode:
            return "Nimbus Test Mode"
        case .coppaOn:
            return "Set COPPA On"
        case .gdprConsent:
            return "GDPR Consent"
        case .forceNoFill:
            return "Force No Fill"
        case .omThirdPartyViewability:
            return "Send OMID Viewability Flag"
        }
    }
    
    func getPrefs() -> Bool {
        switch self {
        case .nimbusTestMode:
            return UserDefaults.standard.nimbusTestMode
        case .coppaOn:
            return UserDefaults.standard.coppaOn
        case .gdprConsent:
            return UserDefaults.standard.gdprConsent
        case .forceNoFill:
            return UserDefaults.standard.forceNoFill
        case .omThirdPartyViewability:
            return UserDefaults.standard.omThirdPartyViewability
        }
    }
    
    func updatePrefs(_ isOn: Bool) {
        switch self {
        case .nimbusTestMode:
            UserDefaults.standard.nimbusTestMode = isOn
        case .coppaOn:
            UserDefaults.standard.coppaOn = isOn
        case .gdprConsent:
            UserDefaults.standard.gdprConsent = isOn
        case .forceNoFill:
            UserDefaults.standard.forceNoFill = isOn
        case .omThirdPartyViewability:
            UserDefaults.standard.omThirdPartyViewability = isOn
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
            if var user = NimbusAdManager.user {
                user.configureGdprConsent(didConsent: newValue)
                NimbusAdManager.user = user
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

extension UserDefaults {
    var omThirdPartyViewability: Bool {
        get {
            register(defaults: [#function: false])
            return bool(forKey: #function)
        }
        set {
            set(newValue, forKey: #function)
            Nimbus.shared.viewabilityProvider?.isThirdPartyViewabilityEnabled = newValue
        }
    }
}
