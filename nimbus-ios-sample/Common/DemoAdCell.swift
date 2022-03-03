//
//  DemoAdCell.swift
//  nimbus-ios-sample
//
//  Created by Victor Takai on 23/11/21.
//

import UIKit
import NimbusKit

final class DemoAdCell: UITableViewCell {
    private(set) var adView: AdView?
    
    static let spacing: CGFloat = 25
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
    }
  
    func setupAdView(adView: AdView) {
        self.adView = adView
        guard let adView = self.adView else { return }

        addSubview(adView)
        
        adView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            adView.centerXAnchor.constraint(equalTo: centerXAnchor),
            adView.topAnchor.constraint(equalTo: topAnchor, constant: DemoAdCell.spacing),
            adView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -DemoAdCell.spacing)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        if let adView = subviews.first(where: { $0 is AdView }) {
            adView.removeFromSuperview()
        }
    }
}
