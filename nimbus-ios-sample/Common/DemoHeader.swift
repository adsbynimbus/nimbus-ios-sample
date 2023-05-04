//
//  DemoHeader.swift
//  nimbus-ios-sample
//
//  Created by Victor Takai on 10/11/21.
//

import UIKit

final class DemoHeader: UITableViewHeaderFooterView {
    private let topSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        return view
    }()
    
    private let bottomSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        return view
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .proximaNova(size: 18, weight: .bold)
        label.textColor = UIColor(named: "labelText")
        return label
    }()
    
    static let height: CGFloat = 76
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        addSubview(topSeparatorView)
        addSubview(bottomSeparatorView)
        addSubview(label)
        
        topSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topSeparatorView.heightAnchor.constraint(equalToConstant: 0.5),
            topSeparatorView.topAnchor.constraint(equalTo: topAnchor),
            topSeparatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topSeparatorView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        bottomSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomSeparatorView.heightAnchor.constraint(equalToConstant: 0.5),
            bottomSeparatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomSeparatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomSeparatorView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: 45),
            label.topAnchor.constraint(equalTo: topSeparatorView.bottomAnchor, constant: 15),
            label.bottomAnchor.constraint(equalTo: bottomSeparatorView.topAnchor, constant: -15),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            label.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateWithSection(_ settingsSection: SettingsSection) {
        accessibilityIdentifier = settingsSection.getIdentifier(prefix: "settings", .header)
        label.text = settingsSection.description
        label.accessibilityIdentifier = settingsSection.getIdentifier(prefix: "settings", .headerLabel)
    }
    
    func updateWithMediationIntegrationType(_ type: MediationIntegrationType) {
        accessibilityIdentifier = type.getIdentifier(prefix: "mediationPlatforms", .header)
        label.text = type.description
        label.accessibilityIdentifier = type.getIdentifier(prefix: "mediationPlatforms", .headerLabel)
    }
    
    func updateWithThirdPartyIntegrationType(_ type: ThirdPartyDemandIntegrationType) {
        let identifier = "thirdPartyDemandIntegration\(type.rawValue.camelCaseToWords())"
        accessibilityIdentifier = type.getIdentifier(prefix: identifier, .header)
        label.text = type.description
        label.accessibilityIdentifier = type.getIdentifier(prefix: identifier, .headerLabel)
    }
}
