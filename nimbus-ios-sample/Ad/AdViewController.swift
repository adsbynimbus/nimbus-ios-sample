//
//  AdViewController.swift
//  nimbus-ios-sample
//
//  Created by Victor Takai on 11/11/21.
//

import UIKit
import NimbusKit
import NimbusRenderVideoKit
import WebKit

final class AdViewController: DemoViewController {
    
    private let ad: NimbusAd
    private let volume: Int
    private let companionAd: NimbusCompanionAd?
    private let dimensions: NimbusAdDimensions?
    private let adViewIdentifier: String
    private let isMaxSize: Bool
    private let shouldInjectIFrameScript: Bool
    private lazy var adContinerView = CustomAdContainerView(
        ad: ad,
        volume: volume,
        companionAd: companionAd,
        viewController: self,
        delegate: self
    )

    init(
        ad: NimbusAd,
        volume: Int = 0,
        companionAd: NimbusCompanionAd? = nil,
        dimensions: NimbusAdDimensions? = nil,
        adViewIdentifier: String,
        headerTitle: String,
        headerSubTitle: String,
        isMaxSize: Bool = false,
        shouldInjectIFrameScript: Bool = false
    ) {
        self.ad = ad
        self.volume = volume
        self.companionAd = companionAd
        self.dimensions = dimensions
        self.adViewIdentifier = adViewIdentifier
        self.isMaxSize = isMaxSize
        self.shouldInjectIFrameScript = shouldInjectIFrameScript
        
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
        
        // If ad is interstitial, this controller will be the one presenting it,
        // so destroying the adView is required otherwise
        if !ad.isInterstitial {
            adContinerView.destroy()
        }
    }
    
    private func setupAdView() {
        view.addSubview(adContinerView)
        
        adContinerView.accessibilityIdentifier = adViewIdentifier
        adContinerView.translatesAutoresizingMaskIntoConstraints = false
        
        if let dimensions = dimensions {
            NSLayoutConstraint.activate([
                adContinerView.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
                adContinerView.safeAreaLayoutGuide.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
                adContinerView.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: CGFloat(dimensions.width)),
                adContinerView.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: CGFloat(dimensions.height)),
            ])
        } else if isMaxSize {
            NSLayoutConstraint.activate([
                adContinerView.safeAreaLayoutGuide.topAnchor.constraint(equalTo: headerView.bottomAnchor),
                adContinerView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                adContinerView.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                adContinerView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                adContinerView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
                adContinerView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor),
                adContinerView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor),
                adContinerView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor),
                adContinerView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        }
    }
    
    private func injectIFrameScript() {
        if let nimbusAdView = adContinerView.subviews.first as? NimbusAdView,
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
