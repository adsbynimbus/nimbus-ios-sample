//
//  APSViewController.swift
//  nimbus-ios-sample
//
//  Created on 02/05/23.
//

import DTBiOSSDK
import NimbusKit
import NimbusRequestAPSKit
import UIKit

extension UIApplicationDelegate {
    func setupAmazonDemand() {
        if let appKey = apsAppKey {
            DTBAds.sharedInstance().setAppKey(appKey)
            DTBAds.sharedInstance().mraidPolicy = CUSTOM_MRAID
            DTBAds.sharedInstance().mraidCustomVersions = ["1.0", "2.0", "3.0"]
            DTBAds.sharedInstance().testMode = Nimbus.shared.testMode
            #if DEBUG
            DTBAds.sharedInstance().setLogLevel(DTBLogLevelDebug)
            #endif
        }
    }
}

let apsAppKey = Bundle.main.infoDictionary?["APS App ID"] as? String

let apsBannerSizes: [DTBAdSize] = [
    .init(bannerAdSizeWithWidth: 320, height: 50, andSlotUUID: "5ab6a4ae-4aa5-43f4-9da4-e30755f2b295")
]

let apsInterstitialSizes: [DTBAdSize] = [
    .init(interstitialAdSizeWithSlotUUID: "4e918ac0-5c68-4fe1-8d26-4e76e8f74831"),
    .init(videoAdSizeWithSlotUUID: "4acc26e6-3ada-4ee8-bae0-753c1e0ad278")
]

final class APSViewController: SampleAdViewController {
    
    private let adType: APSSample
    private var adManager: NimbusAdManager?
    private lazy var requestDispatchGroup = DispatchGroup()
    
    private var callbacks: [DTBCallback] = []
    private var adLoaders: [DTBAdLoader] = []
    private var adSizes: [DTBAdSize]?
    private var adController: AdController?
    
    init(adType: APSSample, headerSubTitle: String) {
        self.adType = adType
        
        super.init(headerTitle: adType.description, headerSubTitle: headerSubTitle)
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

extension APSViewController: NimbusAdManagerDelegate {
    
    func didRenderAd(request: NimbusRequest, ad: NimbusAd, controller: AdController) {
        print("didRenderAd")
        nimbusAd = ad
        controller.register(delegate: self)
        adController = controller
    }
    
    func didCompleteNimbusRequest(request: NimbusRequest, ad: NimbusAd) {
        print("didCompleteNimbusRequest")
    }
    
    func didFailNimbusRequest(request: NimbusRequest, error: NimbusError) {
        print("didFailNimbusRequest: \(error.localizedDescription)")
    }
}

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
