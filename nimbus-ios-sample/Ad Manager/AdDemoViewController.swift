//
//  AdDemoViewController.swift
//  nimbus-ios-sample
//
//  Created by Victor Takai on 11/11/21.
//

import UIKit
import NimbusKit

final class AdDemoViewController: DemoViewController {
    override var headerTitle: String {
        "Show Ad Demo"
    }
    
    override var headerSubTitle: String {
        "Select to see Nimbus' request and render flow"
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.sectionHeaderTopPadding = 0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 75
        tableView.separatorInset = .zero
        tableView.registerCell(DemoCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.accessibilityIdentifier = "adDemoTableView"
        return tableView
    }()
    
    private var adManagerDataSource: [AdManagerAdType] {
        AdManagerAdType.allCases.filter { $0 != .video }
    }
    
    private var facebookDataSource: [FacebookAdType] {
        FacebookAdType.allCases
    }
    
    private var specificAdsDataSource: [AdManagerSpecificAdType] {
        AdManagerSpecificAdType.allCases
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScrollView(tableView)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NimbusAdManager.demandProviders?.removeAll()
        if let aps = DemoDemandProviders.shared.aps {
            NimbusAdManager.demandProviders?.append(aps)
        }
    }
    
    private func createNimbusAd(adType: FacebookAdType) -> NimbusAd {
        switch adType {
            
        case .facebookBanner:
            return createNimbusAd(
                network: "facebook",
                placementId: "IMG_16_9_LINK#\(ConfigManager.shared.fbBannerPlacementId!)",
                auctionType: .static,
                isInterstitial: false
            )
            
        case .facebookNative:
            return createNimbusAd(
                network: "facebook",
                placementId: "IMG_16_9_LINK#\(ConfigManager.shared.fbNativePlacementId!)",
                auctionType: .native,
                isInterstitial: false
            )
            
        case .facebookInterstitial:
            return createNimbusAd(
                network: "facebook",
                placementId: "IMG_16_9_LINK#\(ConfigManager.shared.fbInterstitialPlacementId!)",
                auctionType: .static,
                isInterstitial: true
            )
        }
    }
    
    private func createNimbusAd(
        network: String = "",
        placementId: String? = nil,
        auctionType: NimbusAuctionType,
        markup: String = "",
        isMraid: Bool = true,
        isInterstitial: Bool
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

extension AdDemoViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int { 3 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return adManagerDataSource.count
        } else if section == 1 {
            return facebookDataSource.count
        } else {
            return specificAdsDataSource.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DemoCell = tableView.dequeueReusableCell(for: indexPath)
        if indexPath.section == 0 {
            let adType = adManagerDataSource[indexPath.row]
            cell.updateWithAdManagerAdType(adType)
        } else if indexPath.section == 1 {
            let adType = facebookDataSource[indexPath.row]
            cell.updateWithFacebookAdType(adType)
        } else {
            cell.updateWithSpecificAdManagerAdType(indexPath.row == 0 ? .refreshingBanner : .adsInScrollList)
        }
        return cell
    }
}

extension AdDemoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let adType = adManagerDataSource[indexPath.row]
            if adType == .rewardedVideoUnity
                && ConfigManager.shared.unityGameId.isEmptyOrNil {
                showCustomAlert("unity_game_id")
            } else {
                navigationController?.pushViewController(
                    AdManagerViewController(
                        adType: adType,
                        headerSubTitle: headerTitle
                    ),
                    animated: true
                )
            }
        } else if indexPath.section == 1 {
            let adType = facebookDataSource[indexPath.row]
            if adType == .facebookBanner
                && ConfigManager.shared.fbBannerPlacementId.isEmptyOrNil {
                showCustomAlert("facebook_banner_placement_id")
            } else if adType == .facebookInterstitial
                        && ConfigManager.shared.fbInterstitialPlacementId.isEmptyOrNil {
                showCustomAlert("facebook_interstitial_placement_id")
            } else if adType == .facebookNative
                        && ConfigManager.shared.fbNativePlacementId.isEmptyOrNil {
                showCustomAlert("facebook_native_placement_id")
            } else {
                // Remove all demand providers
                NimbusAdManager.demandProviders?.removeAll()
                
                #if canImport(NimbusRequestFANKit) && canImport(NimbusSDK)
                if let fan = DemoDemandProviders.shared.fan {
                    NimbusAdManager.demandProviders?.append(fan)
                }
                #endif
                
                navigationController?.pushViewController(
                    AdViewController(
                        ad: createNimbusAd(adType: adType),
                        adViewIdentifier: adType.getIdentifier(prefix: "adDemo", .adView),
                        headerTitle: adType.description,
                        headerSubTitle: headerTitle,
                        isMaxSize: true
                    ),
                    animated: true
                )
            }
        } else {
            navigationController?.pushViewController(
                AdManagerSpecificAdViewController(type: indexPath.row == 0 ? .refreshingBanner : .adsInScrollList),
                animated: true
            )
        }
    }
}
