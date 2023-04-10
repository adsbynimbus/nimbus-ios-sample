//
//  AdManagerSpecificAdViewController.swift
//  NimbusInternalSampleApp
//
//  Created by Inder Dhir on 6/10/22.
//  Copyright © 2022 Timehop. All rights reserved.
//

import DTBiOSSDK
import NimbusRequestAPSKit
import NimbusRequestKit
import NimbusKit
import UIKit

final class AdManagerSpecificAdViewController: UIViewController {
    
    let labels = ["Banner Ad below", "Static Image Ad below", "Video Ad below"]
    private let type: AdManagerSpecificAdType
    private lazy var adManager = NimbusAdManager()
    private var nimbusRequestForAPS: NimbusRequest?
    
    private lazy var apsRequestsDispatchGroup = DispatchGroup()
    private var callbacks: [DTBCallback] = []
    private var apsAdLoaders: [DTBAdLoader] = []
    private var adSizes: [DTBAdSize]?
    
    private let collectionView : UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(AdManagerSpecificAdTextCell.self, forCellWithReuseIdentifier: "cellReuse1")
        collectionView.register(AdManagerSpecificAdNimbusCell.self, forCellWithReuseIdentifier: "cellReuse2")
        return collectionView
    }()
    
    init(type: AdManagerSpecificAdType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        switch type {
        case .refreshingBanner:
            showRefreshingBanner()
        case .apsRefreshingBanner:
            showAPSAd(isRefreshingBanner: true)
        case .apsInterstitialHybrid:
            showAPSAd(isRefreshingBanner: false)
        }
    }
    
    private func showRefreshingBanner() {
        let request = NimbusRequest.forBannerAd(position: "refreshing_banner")
        adManager.showAd(request: request, container: view, refreshInterval: 30, adPresentingViewController: self)
    }
    
    private func showAPSAd(isRefreshingBanner: Bool) {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            
            if isRefreshingBanner {
                self.loadAPSBannerAds()
            } else {
                self.loadAPSInterstitialAds()
            }
            
            let result = self.apsRequestsDispatchGroup.wait(timeout: .now() + 0.5)
            switch result {
            case .success:
                print("APS refreshing banner requests completed successfully")
            case .timedOut:
                print("APS refreshing banner requests timed out")
            }
            
            let request: NimbusRequest
            if isRefreshingBanner {
                request = NimbusRequest.forBannerAd(position: "refreshing_banner")
            } else {
                request = NimbusRequest.forInterstitialAd(position: "interstitial_with_aps")
            }
            
            self.callbacks.compactMap { $0.response }.forEach { request.addAPSResponse($0) }
            if isRefreshingBanner {
                self.apsAdLoaders.forEach { request.addAPSLoader($0) }
            }

            DispatchQueue.main.async {
                if isRefreshingBanner {
                    self.adManager.showAd(
                        request: request,
                        container: self.view,
                        refreshInterval: 30,
                        adPresentingViewController: self
                    )
                } else {
                    self.adManager.showAd(request: request, container: self.view, adPresentingViewController: self)
                }
            }
        }
    }
    
    private func loadAPSBannerAds() {
        apsBannerSizes.forEach { [weak self] size in
            guard let self else { return }
            
            self.apsRequestsDispatchGroup.enter()
            
            let adLoader = DTBAdLoader()
            adLoader.setAdSizes([size as Any])
            self.apsAdLoaders.append(adLoader)
            
            let callback = DTBCallback(requestsDispatchGroup: self.apsRequestsDispatchGroup)
            self.callbacks.append(callback)
            adLoader.loadAd(callback)
        }
    }
    
    private func loadAPSInterstitialAds() {
        apsInterstitialSizes.forEach { [weak self] size in
            guard let self else { return }
            
            self.apsRequestsDispatchGroup.enter()

            let adLoader = DTBAdLoader()
            adLoader.setAdSizes([size as Any])
            self.apsAdLoaders.append(adLoader)
            
            let callback = DTBCallback(requestsDispatchGroup: self.apsRequestsDispatchGroup)
            self.callbacks.append(callback)
            adLoader.loadAd(callback)
        }
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
        print("onSuccess \(response))")
        
        response = adResponse
        requestsDispatchGroup.leave()
    }
}
