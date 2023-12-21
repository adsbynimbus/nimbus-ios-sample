//
//  Views.swift
//  nimbus-ios-sample
//
//  Created on 5/28/23.
//

import UIKit

private extension UIView {
    static func label(color: UIColor? = .pink) -> UILabel {
        let label = UILabel()
        label.font = .proximaNova(size: 18, weight: .bold)
        label.textColor = color
        return label
    }
    
    static func separator() -> UIView {
        let view = UIView()
        view.backgroundColor = .separator
        return view
    }
}

class DemoCell: UITableViewCell {
    let label: UILabel = label()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(label)
        
        selectionStyle = .none

        setupAccessoryType()

        label.translatesAutoresizingMaskIntoConstraints = false
        let labelHeight = label.heightAnchor.constraint(equalToConstant: 45)
        labelHeight.priority = UILayoutPriority(999)
        
        NSLayoutConstraint.activate([
            labelHeight,
            label.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            label.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    private func setupAccessoryType() {
        let imageView = UIImageView(image: UIImage(named: "right-arrow")?.withRenderingMode(.alwaysTemplate))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .pink
        imageView.frame = CGRect(x: 0, y: 0, width: 16, height: 16)
        
        accessoryType = .disclosureIndicator
        accessoryView = imageView
    }
}

final class DemoHeader: UITableViewHeaderFooterView {
    
    let label: UILabel = label(color: UIColor(named: "labelText"))
                               
    private let topSeparator: UIView = separator()
    private let bottomSeparator: UIView = separator()
    
    static let height: CGFloat = 76
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        addSubview(topSeparator)
        addSubview(bottomSeparator)
        addSubview(label)
        
        topSeparator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topSeparator.heightAnchor.constraint(equalToConstant: 0.5),
            topSeparator.topAnchor.constraint(equalTo: topAnchor),
            topSeparator.leadingAnchor.constraint(equalTo: leadingAnchor),
            topSeparator.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        bottomSeparator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomSeparator.heightAnchor.constraint(equalToConstant: 0.5),
            bottomSeparator.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomSeparator.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomSeparator.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: 45),
            label.topAnchor.constraint(equalTo: topSeparator.bottomAnchor, constant: 15),
            label.bottomAnchor.constraint(equalTo: bottomSeparator.topAnchor, constant: -15),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            label.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


final class SettingsCell: UITableViewCell {
    let label: UILabel = label(color: .turquoise)
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
        
        switchButton.addTarget(self,
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
