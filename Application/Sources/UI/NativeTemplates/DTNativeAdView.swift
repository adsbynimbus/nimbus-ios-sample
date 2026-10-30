//
//  DTNativeAdView.swift
//  Nimbus
//  Created on 5/29/26
//  Copyright © 2025 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import IASDKCore
import NimbusDTKit

final class DTNativeAdView: UIView, DTNativeAdViewType {
    
    private let assets: IANativeAdAssets
    
    var iconView: UIView?
    weak var headlineView: UILabel?
    weak var advertiserView: UILabel?
    weak var descriptionView: UILabel?
    weak var starRatingView: UIView?
    weak var callToActionView: UIButton?
    
    var mediaView: UIView? { _mediaView }
    let _mediaView = UIView()
    
    var clickableViews: [UIView] {
        [mediaView, callToActionView].compactMap { $0 }
    }
    
    init(assets: IANativeAdAssets) {
        self.assets = assets
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        setupViews()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        let icon = UIImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.tag = ViewTag.icon.rawValue
        addSubview(icon)
        self.iconView = icon
        
        let headline = UILabel()
        headline.translatesAutoresizingMaskIntoConstraints = false
        headline.lineBreakMode = .byWordWrapping
        headline.numberOfLines = 0
        headline.tag = ViewTag.title.rawValue
        addSubview(headline)
        self.headlineView = headline
        
        let body = UILabel()
        body.translatesAutoresizingMaskIntoConstraints = false
        body.font = .systemFont(ofSize: 14)
        body.lineBreakMode = .byWordWrapping
        body.numberOfLines = 0
        body.tag = ViewTag.description.rawValue
        
        addSubview(body)
        self.descriptionView = body
                
        _mediaView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(_mediaView)
        
        var installConfig = UIButton.Configuration.borderedTinted()
        installConfig.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        
        let install = UIButton(configuration: installConfig)
        install.translatesAutoresizingMaskIntoConstraints = false
        install.tag = ViewTag.cta.rawValue
        self.callToActionView = install
        addSubview(install)
        
        NSLayoutConstraint.activate([
            icon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            icon.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            icon.widthAnchor.constraint(equalToConstant: 50),
            icon.heightAnchor.constraint(equalToConstant: 50),
            
            headline.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 8),
            headline.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            headline.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            
            body.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            body.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 16),
            body.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            _mediaView.leadingAnchor.constraint(equalTo: leadingAnchor),
            _mediaView.trailingAnchor.constraint(equalTo: trailingAnchor),
            _mediaView.topAnchor.constraint(equalTo: body.bottomAnchor, constant: 8),
            _mediaView.heightAnchor.constraint(equalToConstant: 200),
            
            install.topAnchor.constraint(equalTo: _mediaView.bottomAnchor, constant: 8),
            install.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            install.widthAnchor.constraint(equalToConstant: 100),
            install.heightAnchor.constraint(equalToConstant: 40),
        ])
        
        setupRatingViewIfNeeded()
    }
    
    func setupRatingViewIfNeeded() {
        guard let nsRating = assets.rating else {
            return
        }
        let rating = Int(truncating: nsRating)
        
        let stars = UIStackView()
        stars.translatesAutoresizingMaskIntoConstraints = false
        stars.axis = .horizontal
        stars.spacing = 8
        stars.distribution = .equalCentering
        stars.tag = ViewTag.rating.rawValue
        
        for i in 0..<5 {
            let style = i < rating ? "star.fill" : "star"
            let starImageView = UIImageView(image: UIImage(systemName: style))
            starImageView.tintColor = .systemYellow
            stars.addArrangedSubview(starImageView)
        }
        
        self.starRatingView = stars
        addSubview(stars)
        
        NSLayoutConstraint.activate([
            stars.topAnchor.constraint(equalTo: _mediaView.bottomAnchor, constant: 16),
            stars.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
        ])
    }
    
    func configure() {
        if let appIcon = assets.appIcon, let iconView {
            appIcon.translatesAutoresizingMaskIntoConstraints = false
            iconView.addSubview(appIcon)
            
            NSLayoutConstraint.activate([
                appIcon.leadingAnchor.constraint(equalTo: iconView.leadingAnchor),
                appIcon.trailingAnchor.constraint(equalTo: iconView.trailingAnchor),
                appIcon.topAnchor.constraint(equalTo: iconView.topAnchor),
                appIcon.bottomAnchor.constraint(equalTo: iconView.bottomAnchor)
            ])
        }
        
        headlineView?.text = assets.adTitle
        descriptionView?.text = assets.adDescription
        callToActionView?.setTitle(assets.callToActionText, for: .normal)
        
        assets.mediaView.translatesAutoresizingMaskIntoConstraints = false
        _mediaView.tag = ViewTag.mediaView.rawValue
        _mediaView.addSubview(assets.mediaView)
            
        NSLayoutConstraint.activate([
            assets.mediaView.leadingAnchor.constraint(equalTo: _mediaView.leadingAnchor),
            assets.mediaView.trailingAnchor.constraint(equalTo: _mediaView.trailingAnchor),
            assets.mediaView.topAnchor.constraint(equalTo: _mediaView.topAnchor),
            assets.mediaView.bottomAnchor.constraint(equalTo: _mediaView.bottomAnchor)
        ])
    }
}
