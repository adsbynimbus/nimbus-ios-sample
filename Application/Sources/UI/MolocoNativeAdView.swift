//
//  MolocoNativeAdView.swift
//  Nimbus
//  Created on 5/29/25
//  Copyright © 2025 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import MolocoSDK
#if canImport(NimbusSDK) // CocoaPods
import NimbusSDK
#else // Swift Package Manager
import NimbusMolocoKit
#endif

final class MolocoNativeAdView: UIView, NimbusMolocoNativeAdViewType {
    
    private let assets: MolocoNativeAdAssests
    
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
    
    init(assets: MolocoNativeAdAssests) {
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
        let rating = Int(assets.rating.rounded())
        
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
        iconView?.image = assets.appIcon
        headlineView?.text = assets.title
        descriptionView?.text = assets.description
        advertiserView?.text = assets.sponsorText
        callToActionView?.setTitle(assets.ctaTitle, for: .normal)
        
        if let mainImage = assets.mainImage {
            let imageView = UIImageView(image: mainImage)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            mediaView.addSubview(imageView)
            
            NSLayoutConstraint.activate([
                imageView.leadingAnchor.constraint(equalTo: mediaView.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: mediaView.trailingAnchor),
                imageView.topAnchor.constraint(equalTo: mediaView.topAnchor),
                imageView.bottomAnchor.constraint(equalTo: mediaView.bottomAnchor)
            ])
        } else if let videoView = assets.videoView {
            videoView.translatesAutoresizingMaskIntoConstraints = false
            mediaView.addSubview(videoView)
            
            NSLayoutConstraint.activate([
                videoView.leadingAnchor.constraint(equalTo: mediaView.leadingAnchor),
                videoView.trailingAnchor.constraint(equalTo: mediaView.trailingAnchor),
                videoView.topAnchor.constraint(equalTo: mediaView.topAnchor),
                videoView.bottomAnchor.constraint(equalTo: mediaView.bottomAnchor)
            ])
        }
    }
}
