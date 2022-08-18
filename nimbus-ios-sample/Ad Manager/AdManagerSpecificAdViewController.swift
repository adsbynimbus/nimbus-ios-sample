//
//  AdManagerSpecificAdViewController.swift
//  NimbusInternalSampleApp
//
//  Created by Inder Dhir on 6/10/22.
//  Copyright © 2022 Timehop. All rights reserved.
//

import UIKit
import NimbusRequestKit
import NimbusKit

final class AdManagerSpecificAdViewController: UIViewController {
    
    let labels = ["Banner Ad below", "Static Image Ad below", "Video Ad below"]
    private let type: AdManagerSpecificAdType
    private lazy var adManager = NimbusAdManager()
    
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
        
        if type == .refreshingBanner {
            let request = NimbusRequest.forBannerAd(position: "refreshing_banner")
            adManager.showAd(request: request, container: view, refreshInterval: 30, adPresentingViewController: self)
        } else {
            view.addSubview(collectionView)
            
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                collectionView.topAnchor.constraint(equalTo: view.topAnchor),
                collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ])
            
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }
}

extension AdManagerSpecificAdViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
            
        case 0, 2, 4:
            let label = labels[indexPath.row / 2]
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "cellReuse1",
                for: indexPath
            ) as! AdManagerSpecificAdTextCell
            cell.update(with: label)
            return cell
            
        case 1:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "cellReuse2",
                for: indexPath
            ) as! AdManagerSpecificAdNimbusCell
            cell.requestNimbusAd(.forBannerAd(position: "banner_ad_in_scroll_view"), with: self)
            
            return cell
            
        case 3:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "cellReuse2",
                for: indexPath
            ) as! AdManagerSpecificAdNimbusCell
            let request = NimbusRequest.forInterstitialAd(position: "static_ad_in_scroll_view")
            request.impressions[0].video = nil
            
            cell.requestNimbusAd(request, with: self)
            return cell
            
        default:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "cellReuse2",
                for: indexPath
            ) as! AdManagerSpecificAdNimbusCell
            let request = NimbusRequest.forInterstitialAd(position: "video_ad_in_scroll_view")
            request.impressions[0].banner = nil
            
            cell.requestNimbusAd(request, with: self)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        6
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let isLabelCell = indexPath.row % 2 == 0
        return .init(width: UIScreen.main.bounds.width, height: isLabelCell ? 50 :  UIScreen.main.bounds.width)
    }
}
