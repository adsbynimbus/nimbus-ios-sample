//
//  VungleViewController.swift
//  NimbusInternalSampleApp
//
//  Created by Bruno Bruggemann on 11/25/22.
//  Copyright © 2022 Timehop. All rights reserved.
//

import UIKit
import NimbusKit

#if canImport(NimbusSDK)
import NimbusSDK
#endif

#if canImport(NimbusRequestAPSKit)
import NimbusRequestAPSKit
#endif

#if canImport(NimbusRequestFANKit)
import NimbusRequestFANKit
#endif

#if canImport(NimbusVungleKit)
import NimbusVungleKit
#endif

#if canImport(NimbusUnityKit)
import NimbusUnityKit
#endif


class VungleViewController: DemoViewController {

    private var adManager: NimbusAdManager?
    private var vungle: NimbusVungleRequestInterceptor?

    override var headerTitle: String {
        "Vungle Test Ads"
    }

    override var headerSubTitle: String {
        "Select to open a Vungle Ad"
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
        tableView.accessibilityIdentifier = "vungleTableView"
        return tableView
    }()

    private var vungleDataSource: [VungleAdType] {
        [
            VungleAdType.vungleBanner,
            VungleAdType.vungleMREC,
            VungleAdType.vungleInterstitial,
            VungleAdType.vungleRewarded
        ]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let vungleAppId = ConfigManager.shared.vungleAppId
        if !vungleAppId.isEmpty {
            vungle = NimbusVungleRequestInterceptor(appId: vungleAppId, isLoggingEnabled: true)
        }

        setupScrollView(tableView)
    }
    
    deinit {
        NimbusAdManager.requestInterceptors?.removeAll(where: {
            $0 is NimbusVungleRequestInterceptor
        })
    }
}

extension VungleViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        vungleDataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DemoCell = tableView.dequeueReusableCell(for: indexPath)
        cell.updateWithVungleAdType(vungleDataSource[indexPath.row])
        return cell
    }
}

extension VungleViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let adType = vungleDataSource[indexPath.row]
        if adType == .vungleBanner
            && ConfigManager.shared.vungleBannerPlacementId.isEmpty {
            showCustomAlert("vungle_banner_placement_id")
        } else if adType == .vungleMREC
                    && ConfigManager.shared.vungleMRECPlacementId.isEmpty {
            showCustomAlert("vungle_mrec_placement_id")
        } else if adType == .vungleInterstitial
                    && ConfigManager.shared.vungleInterstitialPlacementId.isEmpty {
            showCustomAlert("vungle_interstitial_placement_id")
        } else if adType == .vungleRewarded
                    && ConfigManager.shared.vungleRewardedPlacementId.isEmpty {
            showCustomAlert("vungle_rewarded_placement_id")
        } else {
            // Remove other demand providers. It MUST not remove LiveRampInterceptor
            NimbusAdManager.requestInterceptors?.removeAll(where: {
                $0 is NimbusAPSRequestInterceptor ||
                $0 is NimbusUnityRequestInterceptor ||
                $0 is NimbusFANRequestInterceptor
            })
            if let vungle = self.vungle,
               !(NimbusAdManager.requestInterceptors?.contains(where: { $0 is NimbusVungleRequestInterceptor }) ?? false) {
                NimbusAdManager.requestInterceptors?.append(vungle)
            }
            
            let vungleViewController = VungleAdManagerViewController(
                adType: adType,
                headerTitle: adType.description,
                headerSubTitle: headerTitle
            )
            navigationController?.pushViewController(vungleViewController, animated: true)
        }
    }
}

extension VungleViewController: NimbusAdManagerDelegate {

    func didRenderAd(request: NimbusRequestKit.NimbusRequest, ad: NimbusCoreKit.NimbusAd, controller: NimbusCoreKit.AdController) {
        print("didRenderAd")
    }

    func didCompleteNimbusRequest(request: NimbusRequestKit.NimbusRequest, ad: NimbusCoreKit.NimbusAd) {
        print("didCompleteNimbusRequest")
    }

    func didFailNimbusRequest(request: NimbusRequestKit.NimbusRequest, error: NimbusCoreKit.NimbusError) {
        print("didFailNimbusRequest")
    }
}

