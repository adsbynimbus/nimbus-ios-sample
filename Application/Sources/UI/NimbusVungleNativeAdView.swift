//
//  NimbusVungleNativeAdView.swift
//  nimbus-ios-sample
//
//  Created by Victor Takai on 26/09/22.
//  Copyright © 2022 Timehop. All rights reserved.
//
import UIKit
import VungleAdsSDK
import NimbusCoreKit

#if canImport(NimbusSDK) // CocoaPods
import NimbusSDK
#else                    // Swift Package Manager
import NimbusVungleKit
#endif

/// Nimbus default view used for Vungle native ads
final class NimbusVungleNativeAdView: UIView, NimbusVungleNativeAdViewType {

    /// Label used for title
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 1
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    /// Label used for rating
    let adStarRatingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 1
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    /// Label used for sponsor
    let sponsoredLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    /// Label used for body text
    let bodyTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 2
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    /// Button used for call to action
    let callToActionButton: UIButton = {
        let button = UIButton()
        button.contentEdgeInsets = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.titleLabel?.textColor = .white
        button.backgroundColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    /// View used for media
    var mediaView: MediaView = {
        let mediaView = MediaView()
        mediaView.translatesAutoresizingMaskIntoConstraints = false
        return mediaView
    }()

    /// Image view used for icon
    var iconImageView: UIImageView? = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    /// All clickable views
    var clickableViews: [UIView]? { nil }

    /// Spacing between components
    private let spacing: CGFloat = 5

    /**
     Initializes a NimbusVungleNativeAdView instance
     
     - Parameters:
     - vungleNativeAd: Vungle native ad
     - dimensions: Nimbus ad dimensions
     */
    init(_ vungleNativeAd: VungleNative) {
        super.init(frame: CGRect.zero)

        translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = .white

        titleLabel.text = vungleNativeAd.title
        adStarRatingLabel.text = String(vungleNativeAd.adStarRating)
        sponsoredLabel.text = vungleNativeAd.sponsoredText
        bodyTextLabel.text = vungleNativeAd.bodyText
        callToActionButton.setTitle(vungleNativeAd.callToAction, for: .normal)
        iconImageView?.image = vungleNativeAd.iconImage

        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubview(iconImageView!)
        addSubview(titleLabel)
        addSubview(adStarRatingLabel)
        addSubview(sponsoredLabel)
        addSubview(mediaView)
        addSubview(callToActionButton)
        addSubview(bodyTextLabel)

        mediaView.backgroundColor = .green

        NSLayoutConstraint.activate([
            iconImageView!.topAnchor.constraint(equalTo: topAnchor, constant: spacing),
            iconImageView!.leftAnchor.constraint(equalTo: leftAnchor, constant: spacing),
            iconImageView!.heightAnchor.constraint(equalToConstant: 48),
            iconImageView!.widthAnchor.constraint(equalToConstant: 48),
            iconImageView!.bottomAnchor.constraint(lessThanOrEqualTo: mediaView.topAnchor, constant: -spacing),

            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: spacing),
            titleLabel.leftAnchor.constraint(equalTo: iconImageView!.rightAnchor, constant: spacing),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -spacing),

            adStarRatingLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            adStarRatingLabel.leftAnchor.constraint(equalTo: iconImageView!.rightAnchor, constant: spacing),
            adStarRatingLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -spacing),

            sponsoredLabel.topAnchor.constraint(equalTo: adStarRatingLabel.bottomAnchor),
            sponsoredLabel.leftAnchor.constraint(equalTo: iconImageView!.rightAnchor, constant: spacing),
            sponsoredLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -spacing),

            mediaView.topAnchor.constraint(equalTo: sponsoredLabel.bottomAnchor, constant: spacing),
            mediaView.leftAnchor.constraint(equalTo: leftAnchor),
            mediaView.rightAnchor.constraint(equalTo: rightAnchor),

            callToActionButton.topAnchor.constraint(greaterThanOrEqualTo: mediaView.bottomAnchor, constant: spacing * 2),
            callToActionButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -spacing),
            callToActionButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -(spacing * 2)),
            callToActionButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),

            bodyTextLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: spacing),
            bodyTextLabel.centerYAnchor.constraint(equalTo: callToActionButton.centerYAnchor)
        ])
    }
}
