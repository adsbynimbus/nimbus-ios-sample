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
        label.font = .proximaNova(size: 18, weight: .bold)
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
        
    private func setupAccessoryType() {
        let imageView = UIImageView(image: UIImage(named: "right-arrow")?.withRenderingMode(.alwaysTemplate))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .pink
        imageView.frame = CGRect(x: 0, y: 0, width: 16, height: 16)
        
        accessoryType = .disclosureIndicator
        accessoryView = imageView
    }
}
