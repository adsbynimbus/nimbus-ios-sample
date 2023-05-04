//
//  ThirdPartyDemandViewController.swift
//  nimbus-ios-sample
//
//  Created by Bruno Bruggemann on 20/04/23.
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

final class ThirdPartyDemandViewController: DemoViewController {
    
    private var vungleRequestInterceptor: NimbusVungleRequestInterceptor?
    
    override var headerTitle: String {
        "Third Party Demand"
    }
    
    override var headerSubTitle: String {
        "Select to see Nimbus' integration with third party demand"
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.sectionHeaderTopPadding = 0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 75
        tableView.separatorInset = .zero
        tableView.registerCell(DemoCell.self)
        tableView.registerHeaderFooter(DemoHeader.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.accessibilityIdentifier = "thirdPartyDemandTableView"
        return tableView
    }()
    
    private var dataSource: [DemoDataSource<ThirdPartyDemandIntegrationType, ThirdPartyDemandAdType>] {
        [
            DemoDataSource(type: .unity, values: ThirdPartyDemandAdType.unityAdType),
            DemoDataSource(type: .aps, values: ThirdPartyDemandAdType.apsAdType),
            DemoDataSource(type: .fan, values: ThirdPartyDemandAdType.fanAdType),
            DemoDataSource(type: .vungle, values: ThirdPartyDemandAdType.vungleAdType)
        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScrollView(tableView)
    }
    
    private func showController(
        integrationType: ThirdPartyDemandIntegrationType,
        adType: ThirdPartyDemandAdType
    ) {
        switch integrationType {
        case .aps:
            showAPSViewController(adType: adType)
        case .fan:
            showFANViewController(adType: adType)
        case .unity:
            showUnityViewController(adType: adType)
        case .vungle:
            showVungleViewController(adType: adType)
        }
    }
    
    private func showAPSViewController(adType: ThirdPartyDemandAdType) {
        navigationController?.pushViewController(
            APSViewController(
                adType: adType,
                headerTitle: adType.description,
                headerSubTitle: headerTitle
            ),
            animated: true
        )
    }
    
    private func showFANViewController(adType: ThirdPartyDemandAdType) {
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
            navigationController?.pushViewController(
                FANViewController(
                    adType: adType,
                    headerTitle: adType.description,
                    headerSubTitle: headerTitle
                ),
                animated: true
            )
        }
    }
    
    private func showVungleViewController(adType: ThirdPartyDemandAdType) {
        if adType == .vungleBanner
            && ConfigManager.shared.vungleBannerPlacementId.isEmptyOrNil {
            showCustomAlert("vungle_banner_placement_id")
        } else if adType == .vungleMREC
                    && ConfigManager.shared.vungleMRECPlacementId.isEmptyOrNil {
            showCustomAlert("vungle_mrec_placement_id")
        } else if adType == .vungleInterstitial
                    && ConfigManager.shared.vungleInterstitialPlacementId.isEmptyOrNil {
            showCustomAlert("vungle_interstitial_placement_id")
        } else if adType == .vungleRewarded
                    && ConfigManager.shared.vungleRewardedPlacementId.isEmptyOrNil {
            showCustomAlert("vungle_rewarded_placement_id")
        } else {
            navigationController?.pushViewController(
                VungleViewController(
                    adType: adType,
                    headerTitle: adType.description,
                    headerSubTitle: headerTitle
                ),
                animated: true
            )
        }
    }
    
    private func showUnityViewController(adType: ThirdPartyDemandAdType) {
        if adType == .unityRewardedVideo && ConfigManager.shared.unityGameId.isEmptyOrNil {
            showCustomAlert("unity_game_id")
        } else {
            navigationController?.pushViewController(
                UnityViewController(
                    adType: adType,
                    headerTitle: adType.description,
                    headerSubTitle: headerTitle
                ),
                animated: true
            )
        }
    }
}

extension ThirdPartyDemandViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource[section].values.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DemoCell = tableView.dequeueReusableCell(for: indexPath)
        let adType = dataSource[indexPath.section].values[indexPath.row]
        cell.updateWithThirdPartyDemanAdType(adType)
        return cell
    }
}

extension ThirdPartyDemandViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header: DemoHeader = tableView.dequeueReusableHeaderFooterView()
        let integrationType = dataSource[section].type
        header.updateWithThirdPartyIntegrationType(integrationType)
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = dataSource[indexPath.section]
        let integrationType = item.type
        let adType = item.values[indexPath.row]
        showController(integrationType: integrationType, adType: adType)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        DemoHeader.height
    }
}
