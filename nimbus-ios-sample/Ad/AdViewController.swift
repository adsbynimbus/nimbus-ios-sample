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
    private let adViewIdentifier: String
    private let isMaxSize: Bool
    private lazy var adView = AdView(ad: ad, viewController: self)

    init(
        ad: NimbusAd,
        adViewIdentifier: String,
        headerTitle: String,
        headerSubTitle: String,
        isMaxSize: Bool = false
    ) {
        self.ad = ad
        self.adViewIdentifier = adViewIdentifier
        self.isMaxSize = isMaxSize
        super.init(headerTitle: headerTitle, headerSubTitle: headerSubTitle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        if isMaxSize {
            NSLayoutConstraint.activate([
                adView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
                adView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                adView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                adView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                adView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
                adView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor),
                adView.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor),
                adView.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor),
                adView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
            ])
        }
    }
}
