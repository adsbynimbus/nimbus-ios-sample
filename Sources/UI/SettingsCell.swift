//
//  SettingsCell.swift
//  nimbus-ios-sample
//
//  Created by Victor Takai on 10/11/21.
//

import UIKit

final class SettingsCell: UITableViewCell {
    let label: UILabel = {
        let label = UILabel()
        label.font = .proximaNova(size: 18, weight: .bold)
        label.textColor = .turquoise
        return label
    }()
    let switchButton = UISwitch()
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
    
    @objc private func didChangeSwitch(_ switchButton: UISwitch) {
        switchAction?(switchButton.isOn)
    }
}
