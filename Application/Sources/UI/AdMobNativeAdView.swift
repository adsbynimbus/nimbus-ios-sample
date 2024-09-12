//
//  AdMobNativeAdView.swift
//  NimbusInternalSampleApp
//  Created on 9/6/24
//  Copyright © 2024 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import GoogleMobileAds

final class AdMobNativeAdView: GADNativeAdView {
    
    convenience init(nativeAd: GADNativeAd) {
        self.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        setupViews()
        
        /// Set self.adChoicesView before setting nativeAd if you want to use a custom view. For the purpose of this
        /// sample, we defer to the default adChoicesView.
        self.nativeAd = nativeAd
        
        configure()
    }
    
    func setupViews() {
        let icon = UIImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        addSubview(icon)
        self.iconView = icon
        
        let headline = UILabel()
        headline.translatesAutoresizingMaskIntoConstraints = false
        addSubview(headline)
        self.headlineView = headline
        
        let advertiser = UILabel()
        advertiser.translatesAutoresizingMaskIntoConstraints = false
        addSubview(advertiser)
        self.advertiserView = advertiser
        
        let body = UILabel()
        body.translatesAutoresizingMaskIntoConstraints = false
        body.font = .systemFont(ofSize: 14)
        body.lineBreakMode = .byWordWrapping
        body.numberOfLines = 0
        
        addSubview(body)
        self.bodyView = body
        
        let media = GADMediaView()
        media.translatesAutoresizingMaskIntoConstraints = false
        addSubview(media)
        self.mediaView = media
        
        let price = UILabel()
        price.translatesAutoresizingMaskIntoConstraints = false
        self.priceView = price
        
        let store = UILabel()
        store.translatesAutoresizingMaskIntoConstraints = false
        self.storeView = store
        
        var installConfig = UIButton.Configuration.borderedTinted()
        installConfig.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        
        let install = UIButton(configuration: installConfig)
        install.translatesAutoresizingMaskIntoConstraints = false
        // In order for the Google SDK to process touch events properly, user interaction should be disabled.
        install.isUserInteractionEnabled = false
        self.callToActionView = install
        
        let infoView = UIStackView(arrangedSubviews: [price, store, install])
        infoView.translatesAutoresizingMaskIntoConstraints = false
        infoView.axis = .horizontal
        infoView.spacing = 8
        infoView.distribution = .equalSpacing
        addSubview(infoView)
        
        let stars = UIStackView()
        stars.translatesAutoresizingMaskIntoConstraints = false
        stars.axis = .horizontal
        stars.spacing = 8
        stars.distribution = .equalCentering
        addSubview(stars)
        self.starRatingView = stars
        
        if let rating = self.nativeAd?.starRating?.intValue {
            for i in 0..<5 {
                let style = i < rating ? "star.fill" : "star"
                let starImageView = UIImageView(image: UIImage(systemName: style))
                starImageView.tintColor = .systemYellow
                stars.addArrangedSubview(starImageView)
            }
        }
        
        NSLayoutConstraint.activate([
            icon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            icon.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            icon.widthAnchor.constraint(equalToConstant: 50),
            icon.heightAnchor.constraint(equalToConstant: 50),
            
            headline.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 8),
            headline.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            
            advertiser.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 8),
            advertiser.topAnchor.constraint(equalTo: headline.bottomAnchor, constant: 4),
            advertiser.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            body.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            body.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 16),
            body.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            media.centerXAnchor.constraint(equalTo: centerXAnchor),
            media.heightAnchor.constraint(equalToConstant: 200),
            media.topAnchor.constraint(equalTo: body.bottomAnchor, constant: 8),
            
            infoView.topAnchor.constraint(equalTo: media.bottomAnchor, constant: 16),
            infoView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            infoView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            stars.topAnchor.constraint(equalTo: infoView.bottomAnchor, constant: 8),
            stars.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
        ])
    }
    
    func configure() {
        guard let nativeAd else { return }
        
        (iconView as? UIImageView)?.image = nativeAd.icon?.image
        (headlineView as? UILabel)?.text = nativeAd.headline
        (advertiserView as? UILabel)?.text = nativeAd.advertiser
        (bodyView as? UILabel)?.text = nativeAd.body
        mediaView?.mediaContent = nativeAd.mediaContent
        (priceView as? UILabel)?.text = nativeAd.price
        (storeView as? UILabel)?.text = nativeAd.store
        
        // Install button
        (callToActionView as? UIButton)?.setTitle(nativeAd.callToAction, for: .normal)
        callToActionView?.isHidden = nativeAd.callToAction == nil
    }
}
