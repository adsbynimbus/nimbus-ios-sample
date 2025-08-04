//
//  InMobiNativeAdView.swift
//  Nimbus
//  Created on 7/31/25
//  Copyright © 2025 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import InMobiSDK

final class InMobiNativeAdView: UIView {
    
    private let nativeAd: IMNative
    
    weak var iconView: UIImageView?
    weak var headlineView: UILabel?
    weak var advertiserView: UILabel?
    weak var descriptionView: UILabel?
    weak var starRatingView: UIView?
    weak var callToActionView: UIButton?
    
    let mediaView = UIView()
    
    var clickableViews: [UIView] {
        [mediaView, callToActionView].compactMap { $0 }
    }
    
    init(nativeAd: IMNative) {
        self.nativeAd = nativeAd
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
        addSubview(icon)
        self.iconView = icon
        
        let headline = UILabel()
        headline.translatesAutoresizingMaskIntoConstraints = false
        headline.lineBreakMode = .byWordWrapping
        headline.numberOfLines = 0
        addSubview(headline)
        self.headlineView = headline
        
        let advertiser = UILabel()
        advertiser.translatesAutoresizingMaskIntoConstraints = false
        advertiser.lineBreakMode = .byWordWrapping
        advertiser.numberOfLines = 0
        advertiser.textColor = .darkGray
        advertiser.font = .systemFont(ofSize: 15)
        addSubview(advertiser)
        self.advertiserView = advertiser
        
        let body = UILabel()
        body.translatesAutoresizingMaskIntoConstraints = false
        body.font = .systemFont(ofSize: 14)
        body.lineBreakMode = .byWordWrapping
        body.numberOfLines = 0
        
        addSubview(body)
        self.descriptionView = body
                
        mediaView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mediaView)
        
        var installConfig = UIButton.Configuration.borderedTinted()
        installConfig.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        
        let install = UIButton(configuration: installConfig)
        install.translatesAutoresizingMaskIntoConstraints = false
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
            
            advertiser.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 8),
            advertiser.topAnchor.constraint(equalTo: headline.bottomAnchor, constant: 4),
            advertiser.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            body.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            body.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 16),
            body.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            mediaView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mediaView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mediaView.topAnchor.constraint(equalTo: body.bottomAnchor, constant: 8),
            mediaView.heightAnchor.constraint(equalToConstant: 200),
            
            install.topAnchor.constraint(equalTo: mediaView.bottomAnchor, constant: 8),
            install.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            install.widthAnchor.constraint(equalToConstant: 100),
            install.heightAnchor.constraint(equalToConstant: 40),
        ])
        
        setupRatingViewIfNeeded()
    }
    
    func setupRatingViewIfNeeded() {
        guard let strRating = nativeAd.adRating, let rating = Int(strRating) else { return }
        
        let stars = UIStackView()
        stars.translatesAutoresizingMaskIntoConstraints = false
        stars.axis = .horizontal
        stars.spacing = 8
        stars.distribution = .equalCentering
        
        for i in 0..<5 {
            let style = i < rating ? "star.fill" : "star"
            let starImageView = UIImageView(image: UIImage(systemName: style))
            starImageView.tintColor = .systemYellow
            stars.addArrangedSubview(starImageView)
        }
        
        self.starRatingView = stars
        addSubview(stars)
        
        NSLayoutConstraint.activate([
            stars.topAnchor.constraint(equalTo: mediaView.bottomAnchor, constant: 16),
            stars.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
        ])
    }
    
    func configure() {
        iconView?.image = nativeAd.adIcon
        headlineView?.text = nativeAd.adTitle
        descriptionView?.text = nativeAd.description
        advertiserView?.text = "TBD" // TODO: Fix
        callToActionView?.setTitle(nativeAd.adCtaText, for: .normal)
        
        if let primaryView = nativeAd.primaryView(ofWidth: bounds.width) {
            primaryView.translatesAutoresizingMaskIntoConstraints = false
            
            mediaView.addSubview(primaryView)
            
            NSLayoutConstraint.activate([
                primaryView.leadingAnchor.constraint(equalTo: mediaView.leadingAnchor),
                primaryView.trailingAnchor.constraint(equalTo: mediaView.trailingAnchor),
                primaryView.topAnchor.constraint(equalTo: mediaView.topAnchor),
                primaryView.bottomAnchor.constraint(equalTo: mediaView.bottomAnchor)
            ])
        }
    }
}
