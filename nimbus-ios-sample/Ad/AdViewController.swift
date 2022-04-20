//
//  AdViewController.swift
//  nimbus-ios-sample
//
//  Created by Victor Takai on 11/11/21.
//

import UIKit
import NimbusKit
import NimbusRenderVideoKit

final class AdViewController: DemoViewController {
    
    private let ad: NimbusAd
    private let companionAd: NimbusCompanionAd?
    private let dimensions: NimbusAdDimensions?
    private let adViewIdentifier: String
    private let isMaxSize: Bool
    private lazy var adView = AdView(ad: ad, companionAd: companionAd, viewController: self)

    init(
        ad: NimbusAd,
        companionAd: NimbusCompanionAd? = nil,
        dimensions: NimbusAdDimensions? = nil,
        adViewIdentifier: String,
        headerTitle: String,
        headerSubTitle: String,
        isMaxSize: Bool = false
    ) {
        self.ad = ad
        self.companionAd = companionAd
        self.dimensions = dimensions
        self.adViewIdentifier = adViewIdentifier
        self.isMaxSize = isMaxSize
        
        super.init(headerTitle: headerTitle, headerSubTitle: headerSubTitle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        setupAdView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        adView.destroy()
    }
    
    private func setupAdView() {
        view.addSubview(adView)
        
        adView.accessibilityIdentifier = adViewIdentifier
        adView.translatesAutoresizingMaskIntoConstraints = false
        
        if let dimensions = dimensions {
            NSLayoutConstraint.activate([
                adView.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
                adView.safeAreaLayoutGuide.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
                adView.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: CGFloat(dimensions.width)),
                adView.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: CGFloat(dimensions.height)),
            ])
        } else if isMaxSize {
            NSLayoutConstraint.activate([
                adView.safeAreaLayoutGuide.topAnchor.constraint(equalTo: headerView.bottomAnchor),
                adView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                adView.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                adView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                adView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
                adView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor),
                adView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor),
                adView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor),
                adView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        }
    }
}
