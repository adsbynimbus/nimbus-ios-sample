//
//  AdView.swift
//  nimbus-ios-sample
//
//  Created by Victor Takai on 19/11/21.
//

import UIKit
import NimbusKit

final class AdView: UIView {
    private let ad: NimbusAd
    private let companionAd: NimbusCompanionAd?
    private let viewController: UIViewController
    private var hasLoaded = false
    private lazy var nimbusAdView = NimbusAdView(adPresentingViewController: viewController)
    
    init(ad: NimbusAd, companionAd: NimbusCompanionAd? = nil, viewController: UIViewController) {
        self.ad = ad
        self.companionAd = companionAd
        self.viewController = viewController
        
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !hasLoaded {
            setupAdView()
            hasLoaded = true
        }
    }
    
    func destroy() {
        nimbusAdView.destroy()
    }
    
    private func setupAdView() {
        addSubview(nimbusAdView)
        
        nimbusAdView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nimbusAdView.topAnchor.constraint(equalTo: topAnchor),
            nimbusAdView.bottomAnchor.constraint(equalTo: bottomAnchor),
            nimbusAdView.leadingAnchor.constraint(equalTo: leadingAnchor),
            nimbusAdView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        nimbusAdView.render(ad: ad, companionAd: companionAd)
        nimbusAdView.start()
    }
}
