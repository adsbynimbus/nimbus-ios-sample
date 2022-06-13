//
//  AdManagerViewController.swift
//  nimbus-ios-sample
//
//  Created by Victor Takai on 11/11/21.
//

import UIKit
import NimbusKit

final class AdManagerViewController: DemoViewController {
    
    private let contentView = UIView()
    
    private let adType: AdManagerAdType
    private var adManager: NimbusAdManager!
    private var adView: AdView?
    private var manualRequest: NimbusRequest?
    private var requestManager: NimbusRequestManager?

    init(adType: AdManagerAdType, headerTitle: String, headerSubTitle: String) {
        self.adType = adType
        
        super.init(headerTitle: headerTitle, headerSubTitle: headerSubTitle)
    }
    
    init(adType: AdManagerAdType, headerSubTitle: String) {
        self.adType = adType
        
        super.init(headerTitle: adType.description, headerSubTitle: headerSubTitle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupContentView()
        setupAdRendering()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        let nimbusAdView = contentView.subviews.first(where: { $0 is NimbusAdView }) as? NimbusAdView
        nimbusAdView?.destroy()
        adView?.destroy()
        
        NimbusAdManager.demandProviders?.removeAll()
        if let aps = DemoDemandProviders.shared.aps {
            NimbusAdManager.demandProviders?.append(aps)
        }
    }
    
    private func setupContentView() {
        view.addSubview(contentView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            contentView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor),
            contentView.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor),
            contentView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    
    private func setupAdRendering() {
        switch adType {
                     
        case .manualRequestRenderAd:
            // Manual Request Ad
            manualRequest = NimbusRequest.forBannerAd(position: "test_manual_request_banner")
            
            // Manual Render Ad
            requestManager = NimbusRequestManager()
            requestManager?.delegate = self
            requestManager?.performRequest(request: manualRequest!)
            
        case .banner:
            let request = NimbusRequest.forBannerAd(position: "test_banner")

            adManager = NimbusAdManager()
            adManager.delegate = self
            
            adManager.showAd(
                request: request,
                container: contentView,
                adPresentingViewController: self
            )
            
        case .video:
            let request = NimbusRequest.forInterstitialAd(position: "test_video")
            request.impressions[0].banner = nil
            
            adManager = NimbusAdManager()
            adManager.delegate = self
            adManager.showAd(
                request: request,
                container: view,
                adPresentingViewController: self
            )
            
        case .interstitialStatic, .interstitialVideo, .interstitialHybrid:
            let request = NimbusRequest.forInterstitialAd(position: "test_interstitial")
            if adType == .interstitialStatic {
                request.impressions[0].video = nil
            } else if adType == .interstitialVideo {
                request.impressions[0].banner = nil
            }

            adManager = NimbusAdManager()
            adManager.delegate = self
            adManager.showBlockingAd(
                request: request,
                closeButtonDelay: 0,
                adPresentingViewController: self
            )
            
        case .blockingInterstitial:
            let request = NimbusRequest.forInterstitialAd(position: "test_blocking_interstitial")
            
            adManager = NimbusAdManager()
            adManager.delegate = self
            adManager.showBlockingAd(request: request, adPresentingViewController: self)
            
        case .rewardedStatic:
            let request = NimbusRequest.forInterstitialAd(position: "test_rewarded_static")
            request.impressions[0].video = nil
            
            adManager = NimbusAdManager()
            adManager.delegate = self
            adManager.showRewardedAd(request: request, adPresentingViewController: self)
                        
        case .rewardedVideo:
            adManager = NimbusAdManager()
            adManager.delegate = self
            adManager.showRewardedAd(
                request: NimbusRequest.forVideoAd(position: "test_rewarded_video"),
                adPresentingViewController: self
            )
        
        case .rewardedVideoUnity:
            // Remove all demand providers - required for unity
            NimbusAdManager.demandProviders?.removeAll()
            
            if let unity = DemoDemandProviders.shared.unity {
                NimbusAdManager.demandProviders?.append(unity)
            }
            
            adManager = NimbusAdManager()
            adManager.delegate = self
            adManager.showRewardedAd(
                request: NimbusRequest.forVideoAd(position: "Rewarded_iOS"),
                adPresentingViewController: self
            )
        }
    }
    
    private func setupAdView(adView: AdView?) {
        guard let adView = adView else { return }
        contentView.addSubview(adView)

        adView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            adView.topAnchor.constraint(equalTo: contentView.topAnchor),
            adView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor),
            adView.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor),
            adView.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor),
            adView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
    }
}

// MARK: NimbusAdManagerDelegate

extension AdManagerViewController: NimbusAdManagerDelegate {
    func didRenderAd(request: NimbusRequest, ad: NimbusAd, controller: AdController) {
        print("didRenderAd")
    }
}

// MARK: NimbusRequestManagerDelegate

extension AdManagerViewController: NimbusRequestManagerDelegate {
    func didCompleteNimbusRequest(request: NimbusRequest, ad: NimbusAd) {
        print("didCompleteNimbusRequest")
        
        if manualRequest == request {
            adView = AdView(ad: ad, viewController: self)
            adView?.accessibilityIdentifier = "adManagerManualRequestRenderAdView"
            setupAdView(adView: adView)
        }
    }

    func didFailNimbusRequest(request: NimbusRequest, error: NimbusError) {
        print("didFailNimbusRequest: \(error.localizedDescription)")
    }
}
