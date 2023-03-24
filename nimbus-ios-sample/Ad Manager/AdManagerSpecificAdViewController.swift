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
    private var apsAdLoader: DTBAdLoader?
    
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
        case .interstitialWithAPS:
            showInterstitialWithAPS()
        }
    }
    
    private func showRefreshingBanner() {
        let request = NimbusRequest.forBannerAd(position: "refreshing_banner")
        adManager.showAd(request: request, container: view, refreshInterval: 30, adPresentingViewController: self)
    }
    
    private func showInterstitialWithAPS() {
        nimbusRequestForAPS = NimbusRequest.forInterstitialAd(position: "interstitial_with_aps")
        
        apsAdLoader = DTBAdLoader()
        apsAdLoader?.setAdSizes([apsAdSizes as Any])
        apsAdLoader?.loadAd(self)
    }
    
    private func showAdWithAPS() {
        if let nimbusRequestForAPS {
            adManager.showAd(request: nimbusRequestForAPS, container: view, adPresentingViewController: self)
        }
    }
}

// MARK: DTBAdCallback

extension AdManagerSpecificAdViewController: DTBAdCallback {

    /// :nodoc:
    func onSuccess(_ adResponse: DTBAdResponse!) {
        print("APS response successful!")
        
        nimbusRequestForAPS?.addAPSResponse(adResponse)
        showAdWithAPS()
    }
    
    func onFailure(_ error: DTBAdError) {
        print("APS response failed! Error: \(error)")

        showAdWithAPS()
    }
}
