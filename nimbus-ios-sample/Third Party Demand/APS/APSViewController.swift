//
//  APSViewController.swift
//  nimbus-ios-sample
//
//  Created by Victor Takai on 02/05/23.
//

import UIKit
import NimbusKit
import NimbusRequestKit
import NimbusRequestAPSKit
import DTBiOSSDK

final class APSViewController: DemoViewController {
    
    private let adType: ThirdPartyDemandAdType
    private var adManager: NimbusAdManager?
    private lazy var requestDispatchGroup = DispatchGroup()
    
    private var callbacks: [DTBCallback] = []
    private var adLoaders: [DTBAdLoader] = []
    private var adSizes: [DTBAdSize]?
    
    init(
        adType: ThirdPartyDemandAdType,
        headerTitle: String,
        headerSubTitle: String
    ) {
        self.adType = adType
        
        super.init(headerTitle: headerTitle, headerSubTitle: headerSubTitle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAdRendering()
    }
    
    private func setupAdRendering() {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            
            self.adManager = NimbusAdManager()
            self.adManager?.delegate = self
            
            if self.adType == .apsRefreshingBanner {
                self.loadAPSBannerAds()
            } else if self.adType == .apsInterstitialHybrid {
                self.loadAPSInterstitialAds()
            }
            
            let result = self.requestDispatchGroup.wait(timeout: .now() + 0.5)
            switch result {
            case .success:
                print("APS refreshing banner requests completed successfully")
            case .timedOut:
                print("APS refreshing banner requests timed out")
            }
            
            let request: NimbusRequest
            if self.adType == .apsRefreshingBanner {
                request = NimbusRequest.forBannerAd(position: "refreshing_banner")
            } else {
                request = NimbusRequest.forInterstitialAd(position: "interstitial_with_aps")
            }
            
            self.callbacks.compactMap { $0.response }.forEach { request.addAPSResponse($0) }
            
            if self.adType == .apsRefreshingBanner {
                self.adLoaders.forEach { request.addAPSLoader($0) }
            }
            
            DispatchQueue.main.async {
                if self.adType == .apsRefreshingBanner {
                    self.adManager?.showAd(
                        request: request,
                        container: self.view,
                        refreshInterval: 30,
                        adPresentingViewController: self
                    )
                } else {
                    self.adManager?.showAd(
                        request: request,
                        container: self.view,
                        adPresentingViewController: self
                    )
                }
            }
        }
    }
    
    private func loadAPSBannerAds() {
        apsBannerSizes.forEach { [weak self] size in
            guard let self else { return }
            
            self.requestDispatchGroup.enter()
            
            let adLoader = DTBAdLoader()
            adLoader.setAdSizes([size as Any])
            self.adLoaders.append(adLoader)
            
            let callback = DTBCallback(requestsDispatchGroup: self.requestDispatchGroup)
            self.callbacks.append(callback)
            adLoader.loadAd(callback)
        }
    }
    
    private func loadAPSInterstitialAds() {
        apsInterstitialSizes.forEach { [weak self] size in
            guard let self else { return }
            
            self.requestDispatchGroup.enter()
            
            let adLoader = DTBAdLoader()
            adLoader.setAdSizes([size as Any])
            self.adLoaders.append(adLoader)
            
            let callback = DTBCallback(requestsDispatchGroup: self.requestDispatchGroup)
            self.callbacks.append(callback)
            adLoader.loadAd(callback)
        }
    }
}

// MARK: NimbusAdManagerDelegate

extension APSViewController: NimbusAdManagerDelegate {
    
    func didRenderAd(request: NimbusRequest, ad: NimbusAd, controller: AdController) {
        print("didRenderAd")
        controller.adView?.accessibilityIdentifier = "nimbus_ad_view"
        controller.adView?.accessibilityLabel = "\(ad.network) \(ad.auctionType.rawValue) ad"
    }
}

// MARK: NimbusRequestManagerDelegate

extension APSViewController: NimbusRequestManagerDelegate {
    
    func didCompleteNimbusRequest(request: NimbusRequest, ad: NimbusAd) {
        print("didCompleteNimbusRequest")
    }
    
    func didFailNimbusRequest(request: NimbusRequest, error: NimbusError) {
        print("didFailNimbusRequest: \(error.localizedDescription)")
    }
}

// MARK: DTBAdCallback

/// :nodoc:
final class DTBCallback: DTBAdCallback {
    
    private let requestsDispatchGroup: DispatchGroup
    var response: DTBAdResponse?
    
    init(requestsDispatchGroup: DispatchGroup) {
        self.requestsDispatchGroup = requestsDispatchGroup
    }
    
    /// :nodoc:
    public func onFailure(_ error: DTBAdError) {
        print("onFailure \(error))")
        
        requestsDispatchGroup.leave()
    }
    
    /// :nodoc:
    public func onSuccess(_ adResponse: DTBAdResponse!) {
        print("onSuccess \(adResponse!))")
        
        response = adResponse
        requestsDispatchGroup.leave()
    }
}
