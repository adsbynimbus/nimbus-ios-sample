//
//  DemoCell.swift
//  nimbus-ios-sample
//
//  Created by Victor Takai on 09/11/21.
//

import UIKit

class DemoCell: UITableViewCell {
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.proximaNova(size: 18, weight: .bold)
        label.textColor = .pink
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        setupAccessoryType()
        
        addSubview(label)

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
    
    func updateWithMainItem(_ item: MainItem) {
        accessibilityIdentifier = item.getIdentifier(prefix: "main", .cell)
        label.text = item.description
        label.accessibilityIdentifier = item.getIdentifier(prefix: "main", .cellLabel)
    }
    
    func updateWithAdManagerAdType(_ adType: AdManagerAdType) {
        accessibilityIdentifier = adType.getIdentifier(prefix: "adDemo", .cell)
        label.text = adType.description
        label.accessibilityIdentifier = adType.getIdentifier(prefix: "adDemo", .cellLabel)
    }
    
    func updateWithSpecificAdManagerAdType(_ adType: AdManagerSpecificAdType) {
        accessibilityIdentifier = adType.getIdentifier(prefix: "adDemo", .cell)
        label.text = adType.description
        label.accessibilityIdentifier = adType.getIdentifier(prefix: "adDemo", .cellLabel)
    }
    
    func updateWithFacebookAdType(_ adType: FacebookAdType) {
        accessibilityIdentifier = adType.getIdentifier(prefix: "adDemo", .cell)
        label.text = adType.description
        label.accessibilityIdentifier = adType.getIdentifier(prefix: "adDemo", .cellLabel)
    }
    
    func updateWithMediationAdType(_ adType: MediationAdType) {
        accessibilityIdentifier = adType.getIdentifier(prefix: "mediationPlatforms", .cell)
        label.text = adType.description
        label.accessibilityIdentifier = adType.getIdentifier(prefix: "mediationPlatforms", .cellLabel)
    }
        
    private func setupAccessoryType() {
        let image = UIImage(named: "right-arrow")?.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .pink
        imageView.frame = CGRect(x: 0, y: 0, width: 16, height: 16)
        
        accessoryType = .disclosureIndicator
        accessoryView = imageView
    }
}
