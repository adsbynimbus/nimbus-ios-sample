//
//  AdViewController.swift
//  nimbus-ios-sample
//
//  Created by Victor Takai on 11/11/21.
//

import UIKit
import NimbusKit
import NimbusRenderStaticKit
import NimbusRenderVideoKit
import WebKit

final class AdViewController: DemoViewController {
    
    private let ad: NimbusAd
    private let volume: Int
    private let companionAd: NimbusCompanionAd?
    private let dimensions: NimbusAdDimensions?
    private let adViewIdentifier: String
    private let creativeScalingEnabledForStaticAds: Bool
    private let isMaxSize: Bool
    private let shouldInjectIFrameScript: Bool
    private var adContainerView: CustomAdContainerView!

    init(
        ad: NimbusAd,
        volume: Int = 0,
        companionAd: NimbusCompanionAd? = nil,
        dimensions: NimbusAdDimensions? = nil,
        adViewIdentifier: String,
        headerTitle: String,
        headerSubTitle: String,
        creativeScalingEnabledForStaticAds: Bool = true,
        isMaxSize: Bool = false,
        shouldInjectIFrameScript: Bool = false
    ) {
        self.ad = ad
        self.volume = volume
        self.companionAd = companionAd
        self.dimensions = dimensions
        self.adViewIdentifier = adViewIdentifier
        self.creativeScalingEnabledForStaticAds = creativeScalingEnabledForStaticAds
        self.isMaxSize = isMaxSize
        self.shouldInjectIFrameScript = shouldInjectIFrameScript
        
        super.init(headerTitle: headerTitle, headerSubTitle: headerSubTitle)

        self.adContainerView = CustomAdContainerView(
            ad: ad,
            companionAd: companionAd,
            viewController: self,
            creativeScalingEnabledForStaticAds: creativeScalingEnabledForStaticAds,
            delegate: self
        )
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
        
        // If ad is interstitial, this controller will be the one presenting it,
        // so destroying the adView is required otherwise
        if !ad.isInterstitial {
            adContainerView.destroy()
        }
    }
    
    private func setupAdView() {
        view.addSubview(adContainerView)
        
        adContainerView.accessibilityIdentifier = adViewIdentifier
        adContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        if let dimensions = dimensions {
            NSLayoutConstraint.activate([
                adContainerView.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
                adContainerView.safeAreaLayoutGuide.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
                adContainerView.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: CGFloat(dimensions.width)),
                adContainerView.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: CGFloat(dimensions.height)),
            ])
        } else if isMaxSize {
            NSLayoutConstraint.activate([
                adContainerView.safeAreaLayoutGuide.topAnchor.constraint(equalTo: headerView.bottomAnchor),
                adContainerView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                adContainerView.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                adContainerView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                adContainerView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
                adContainerView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor),
                adContainerView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor),
                adContainerView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor),
                adContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        }
    }
    
    private func injectIFrameScript() {
        if let nimbusAdView = adContainerView.subviews.first as? NimbusAdView,
            let webView = nimbusAdView.subviews.first as? WKWebView {
            let path = Bundle.main.path(forResource: "mraid_iframe", ofType: "js")!
            let jsString = (try? String(contentsOfFile: path, encoding: .utf8)) ?? ""
            webView.evaluateJavaScript(jsString, completionHandler: { _, error in
                if let error = error {
                    print("Failed to inject IFrame script \(error)")
                }
            })
        }
    }
}

extension AdViewController: AdControllerDelegate {
    func didReceiveNimbusEvent(controller: AdController, event: NimbusEvent) {
        if event == .loaded && shouldInjectIFrameScript {
            injectIFrameScript()
        }
    }
    
    func didReceiveNimbusError(controller: AdController, error: NimbusError) {}
}
