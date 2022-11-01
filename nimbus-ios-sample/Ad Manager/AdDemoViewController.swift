//
//  AdDemoViewController.swift
//  nimbus-ios-sample
//
//  Created by Victor Takai on 11/11/21.
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

final class AdDemoViewController: DemoViewController {

    private var adManager: NimbusAdManager?

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

    private var vungleDataSource: [VungleAdType] {
        VungleAdType.allCases
    }

    private var specificAdsDataSource: [AdManagerSpecificAdType] {
        AdManagerSpecificAdType.allCases
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupScrollView(tableView)
    }

    private func createNimbusAd(adType: FacebookAdType) -> NimbusAd {
        switch adType {

        case .facebookBanner:
            return createNimbusAd(
                network: "facebook",
                placementId: "IMG_16_9_LINK#\(ConfigManager.shared.fbBannerPlacementId!)",
                auctionType: .static,
                isInterstitial: false,
                adDimensions: NimbusAdDimensions(width: 300, height: 50)
            )

        case .facebookInterstitial:
            return createNimbusAd(
                network: "facebook",
                placementId: "IMG_16_9_LINK#\(ConfigManager.shared.fbInterstitialPlacementId!)",
                auctionType: .static,
                isInterstitial: true,
                adDimensions: nil
            )

        case .facebookNative:
            return createNimbusAd(
                network: "facebook",
                placementId: "IMG_16_9_LINK#\(ConfigManager.shared.fbNativePlacementId!)",
                auctionType: .native,
                isInterstitial: false,
                adDimensions: NimbusAdDimensions(width: 320, height: 480)
            )
        }
    }



    private func createNimbusAd(
        network: String = "",
        placementId: String? = nil,
        auctionType: NimbusAuctionType,
        markup: String = "",
        isMraid: Bool = true,
        isInterstitial: Bool,
        adDimensions: NimbusAdDimensions? = nil
    ) -> NimbusAd {
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

    func numberOfSections(in tableView: UITableView) -> Int { 4 }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return adManagerDataSource.count
        } else if section == 1 {
            return facebookDataSource.count
        } else if section == 2 {
            return vungleDataSource.count
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
        } else if indexPath.section == 2 {
            let adType = vungleDataSource[indexPath.row]
            cell.updateWithVungleAdType(adType)
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

                // Remove other demand providers. It MUST not remove LiveRampInterceptor
                NimbusAdManager.requestInterceptors?.removeAll(where: {
                    $0 is NimbusAPSRequestInterceptor ||
                    $0 is NimbusUnityRequestInterceptor ||
                    $0 is NimbusVungleRequestInterceptor
                })
                if let fan = DemoRequestInterceptors.shared.fan,
                   !(NimbusAdManager.requestInterceptors?.contains(where: { $0 is NimbusFANRequestInterceptor }) ?? false) {
                    NimbusAdManager.requestInterceptors?.append(fan)
                }

                let ad = createNimbusAd(adType: adType)
                navigationController?.pushViewController(
                    AdViewController(
                        ad: ad,
                        dimensions: ad.adDimensions,
                        adViewIdentifier: adType.getIdentifier(prefix: "adDemo", .adView),
                        headerTitle: adType.description,
                        headerSubTitle: headerTitle,
                        isMaxSize: true
                    ),
                    animated: true
                )
            }
        } else if indexPath.section == 2 {
            let adType = vungleDataSource[indexPath.row]
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

                // Remove other demand providers. It MUST not remove LiveRampInterceptor
                NimbusAdManager.requestInterceptors?.removeAll(where: {
                    $0 is NimbusAPSRequestInterceptor ||
                    $0 is NimbusUnityRequestInterceptor ||
                    $0 is NimbusFANRequestInterceptor
                })
                if let vungle = DemoRequestInterceptors.shared.vungle,
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
        } else {
            navigationController?.pushViewController(
                AdManagerSpecificAdViewController(type: indexPath.row == 0 ? .refreshingBanner : .adsInScrollList),
                animated: true
            )
        }
    }
}

extension AdDemoViewController: NimbusAdManagerDelegate {

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
