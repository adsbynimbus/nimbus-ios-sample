//
//  SettingsCell.swift
//  nimbus-ios-sample
//
//  Created by Victor Takai on 10/11/21.
//

import UIKit

final class SettingsCell: UITableViewCell {
    private let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.proximaNova(size: 18, weight: .bold)
        label.textColor = .turquoise
        return label
    }()
    
    private let switchButton = UISwitch()
    
    var switchAction: ((Bool) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        accessoryView = switchButton
        
        addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        let labelHeight = label.heightAnchor.constraint(equalToConstant: 45)
        labelHeight.priority = UILayoutPriority(999)
        
        NSLayoutConstraint.activate([
            labelHeight,
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        switchButton.addTarget(
            self,
            action: #selector(didChangeSwitch(_:)),
            for: .valueChanged
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateWithSetting(_ setting: Setting) {
        accessibilityIdentifier = setting.getIdentifier(prefix: "settings", .cell)
        
        label.text = setting.description
        label.accessibilityIdentifier = setting.getIdentifier(prefix: "settings", .cellLabel)
        
        switchButton.setOn(setting.getPrefs(), animated: false)
        switchButton.accessibilityIdentifier = setting.getIdentifier(prefix: "settings", .cellSwitch)
        switchAction = { isOn in
            setting.updatePrefs(isOn)
        }
    }
    
    @objc private func didChangeSwitch(_ switchButton: UISwitch) {
        switchAction?(switchButton.isOn)
    }
}
