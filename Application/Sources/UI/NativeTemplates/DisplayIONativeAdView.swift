//
//  DisplayIONativeAdView.swift
//  Nimbus
//  Created on 7/8/26
//  Copyright © 2026 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import NimbusDisplayIOKit
import DIOSDK

final class DisplayIONativeAdView: UIView, DisplayIONativeAdViewType {
    // SDK-managed slots — your app only decides their size and position.
    let iconSlot: DIONativeMediaView? = DIONativeMediaView()
    let mediaSlot = DIONativeMediaView()

    // App-owned views — fonts, colors, fitting are entirely up to you.
    let headlineLabel: UILabel? = UILabel()
    let ctaButton: UIButton? = {
        var config = UIButton.Configuration.borderedTinted()
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let advertiser = UILabel()
    private let body = UILabel()
    private let price = UILabel()

    // Privacy "ⓘ" — the SDK does not render it; your app does and opens
    // the privacy URL on tap.
    private let privacy = UILabel()
    private var privacyUrl: String?

    init(nativeAd: any DIONativeAdInterface) {
        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false

        privacy.text = "ⓘ"
        privacy.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(privacyTapped))
        privacy.addGestureRecognizer(tap)

        setUpViewHierarchy()
        bind(ad: nativeAd)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout (built once)

    private func setUpViewHierarchy() {
        guard let iconSlot, let headlineLabel, let ctaButton else { return }

        // Icon — small square, rounded corners
        iconSlot.translatesAutoresizingMaskIntoConstraints = false
        iconSlot.layer.cornerRadius = 8
        iconSlot.clipsToBounds = true

        // Headline + "Sponsored" stacked next to the icon
        headlineLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        headlineLabel.numberOfLines = 1

        advertiser.font = .systemFont(ofSize: 12)
        advertiser.textColor = .secondaryLabel

        let textStack = UIStackView(arrangedSubviews: [headlineLabel, advertiser])
        textStack.axis = .vertical
        textStack.spacing = 2

        privacy.font = .systemFont(ofSize: 14)
        privacy.setContentHuggingPriority(.required, for: .horizontal)

        let topRow = UIStackView(arrangedSubviews: [iconSlot, textStack, privacy])
        topRow.axis = .horizontal
        topRow.alignment = .center
        topRow.spacing = 8

        // Media — the big image/video slot
        mediaSlot.translatesAutoresizingMaskIntoConstraints = false
        mediaSlot.layer.cornerRadius = 8
        mediaSlot.clipsToBounds = true

        // Body copy under the media
        body.font = .systemFont(ofSize: 13)
        body.numberOfLines = 2

        // Price + CTA on the bottom row
        price.font = .systemFont(ofSize: 13, weight: .medium)
        price.setContentHuggingPriority(.required, for: .horizontal)

        ctaButton.backgroundColor = .systemBlue
        ctaButton.setTitleColor(.white, for: .normal)

        let bottomRow = UIStackView(arrangedSubviews: [price, ctaButton])
        bottomRow.axis = .horizontal
        bottomRow.alignment = .center
        bottomRow.distribution = .equalSpacing

        let mainStack = UIStackView(arrangedSubviews: [topRow, mediaSlot, body, bottomRow])
        mainStack.axis = .vertical
        mainStack.distribution = .fillProportionally
        mainStack.spacing = 8
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(mainStack)

        NSLayoutConstraint.activate([
            iconSlot.widthAnchor.constraint(equalToConstant: 40),
            iconSlot.heightAnchor.constraint(equalToConstant: 40),

            mediaSlot.heightAnchor.constraint(equalTo: mediaSlot.widthAnchor, multiplier: 9.0 / 16.0),

            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            mainStack.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            mainStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }

    func bind(ad: any DIONativeAdInterface) {
        headlineLabel?.text = ad.headline()
        body.text = ad.body()
        price.text = ad.price()
        ctaButton?.setTitle(ad.callToAction(), for: .normal)

        advertiser.text = "Sponsored"
        privacyUrl = ad.privacy()
        privacy.isHidden = privacyUrl?.isEmpty ?? true

        mediaSlot.blurBackgroundEnabled = !ad.hasVideoContent()
    }

    @objc private func privacyTapped() {
        guard let privacyUrl = privacyUrl, let url = URL(string: privacyUrl) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
