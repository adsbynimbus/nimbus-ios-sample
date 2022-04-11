//
//  TestRenderAdViewController.swift
//  nimbus-ios-sample
//
//  Created by Victor Takai on 22/11/21.
//

import UIKit
import NimbusKit

final class TestRenderAdViewController: UIViewController {
    private let adMarkup: String
    
    private lazy var adView: AdView? = {
        guard let ad = getAdFromMarkup(adMarkup: adMarkup) else {
            return nil
        }
        return AdView(ad: ad, viewController: self)
    }()
    
    init(adMarkup: String) {
        self.adMarkup = adMarkup
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setupLogo()
        setupAdView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        adView?.destroy()
    }
    
    private func setupAdView() {
        guard let adView = adView else { return }
        view.addSubview(adView)
        
        adView.accessibilityIdentifier = "testRenderAdView"
        adView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            adView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            adView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            adView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            adView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func getAdFromMarkup(adMarkup: String) -> NimbusAd? {
        let isVideo = adMarkup.components(separatedBy: " ").first?.contains("xml") == true ||
            adMarkup.components(separatedBy: " ").first?.lowercased().contains("vast") == true
        if isVideo {
            return createNimbusAd(auctionType: .video, markup: adMarkup)
        } else if adMarkup.components(separatedBy: " ").first?.contains("html") == true {
            return createNimbusAd(auctionType: .static, markup: adMarkup)
        }
        return nil
    }
    
    private func createNimbusAd(
        network: String = "",
        placementId: String? = nil,
        auctionType: NimbusAuctionType,
        markup: String,
        isMraid: Bool = true,
        isInterstitial: Bool = true
    ) -> NimbusAd {
        let adDimensions = isInterstitial ?
        NimbusAdDimensions(width: 320, height: 480) :
        NimbusAdDimensions(width: 300, height: 50)
        return NimbusAd(
            position: "",
            auctionType: auctionType,
            bidRaw: 0,
            bidInCents: 0,
            contentType: "",
            auctionId: "",
            network: network,
            markup: markup,
            isInterstitial: isInterstitial,
            placementId: placementId ?? "",
            duration: nil,
            adDimensions: adDimensions,
            trackers: nil,
            isMraid: isMraid,
            extensions: nil
        )
    }
}
