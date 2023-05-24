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
    private var nimbusAd: NimbusAd?
    private var adController: AdController?
    
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
    
    deinit {
        adController?.destroy()
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
            
            if self.adType == .apsBannerWithRefresh {
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
            if self.adType == .apsBannerWithRefresh {
                request = NimbusRequest.forBannerAd(position: self.adType.description)
            } else {
                request = NimbusRequest.forInterstitialAd(position: self.adType.description)
            }
            
            self.callbacks.compactMap { $0.response }.forEach { request.addAPSResponse($0) }
            
            if self.adType == .apsBannerWithRefresh {
                self.adLoaders.forEach { request.addAPSLoader($0) }
            }
            
            DispatchQueue.main.async {
                if self.adType == .apsBannerWithRefresh {
                    self.adManager?.showAd(
                        request: request,
                        container: self.view,
                        refreshInterval: 30,
                        adPresentingViewController: self
                    )
                } else {
                    self.adManager?.showBlockingAd(
                        request: request,
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
        nimbusAd = ad
        controller.delegate = self
        adController = controller
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

extension APSViewController: AdControllerDelegate {
    func didReceiveNimbusEvent(controller: AdController, event: NimbusEvent) {
        if let ad = nimbusAd, event == .loaded {
            controller.adView?.setUiTestIdentifiers(for: ad, refreshing: adType == .apsBannerWithRefresh)
        }
    }
    
    func didReceiveNimbusError(controller: AdController, error: NimbusError) {    }
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
