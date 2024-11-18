//
//  MintegralNativeAdView.swift
//  Nimbus
//  Created on 11/8/24
//  Copyright © 2024 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import MTGSDK
#if canImport(NimbusSDK) // CocoaPods
import NimbusSDK
#elseif canImport(NimbusMintegralKit) // Swift Package Manager
import NimbusMintegralKit
#endif

final class MintegralNativeAdView: UIView, NimbusMintegralNativeAdViewType {
    let mediaView: MTGMediaView = {
        let media = MTGMediaView(frame: .zero)
        media.translatesAutoresizingMaskIntoConstraints = false
        return media
    }()
    
    var clickableViews: [UIView] {
        [mediaView, bodyView].compactMap { $0 }
    }
    
    private let campaign: MTGCampaign
    
    private weak var iconView: UIImageView?
    private weak var headlineView: UILabel?
    private weak var bodyView: UILabel?
    private weak var installButton: UIButton?
    private weak var adChoicesView: MTGAdChoicesView?
    
    init(campaign: MTGCampaign) {
        self.campaign = campaign
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
        
        let body = UILabel()
        body.translatesAutoresizingMaskIntoConstraints = false
        body.font = .systemFont(ofSize: 14)
        body.lineBreakMode = .byWordWrapping
        body.numberOfLines = 0
        
        addSubview(body)
        self.bodyView = body
        
        var installConfig = UIButton.Configuration.borderedTinted()
        installConfig.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        
        if campaign.adChoiceIconSize != .zero {
            let adChoicesView = MTGAdChoicesView(frame: .zero)
            adChoicesView.translatesAutoresizingMaskIntoConstraints = false
            adChoicesView.campaign = campaign
            
            addSubview(adChoicesView)
            self.adChoicesView = adChoicesView
            
            NSLayoutConstraint.activate([
                adChoicesView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
                adChoicesView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
                adChoicesView.widthAnchor.constraint(equalToConstant: campaign.adChoiceIconSize.width),
                adChoicesView.heightAnchor.constraint(equalToConstant: campaign.adChoiceIconSize.height),
            ])
        }
        
        addSubview(mediaView)
        
        let install = UIButton(configuration: installConfig)
        install.translatesAutoresizingMaskIntoConstraints = false
        addSubview(install)
        self.installButton = install
        
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
            
            mediaView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mediaView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mediaView.topAnchor.constraint(equalTo: body.bottomAnchor, constant: 8),
            mediaView.heightAnchor.constraint(equalToConstant: 200),
            
            install.topAnchor.constraint(equalTo: mediaView.bottomAnchor, constant: 16),
            install.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            install.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
    }
    
    func configure() {
        headlineView?.text = campaign.appName;
        bodyView?.text = campaign.appDesc;
        installButton?.setTitle(campaign.adCall, for: .normal)
        
        campaign.loadIconUrlAsync { [weak self] image in
            self?.iconView?.image = image
        }
    }
}
