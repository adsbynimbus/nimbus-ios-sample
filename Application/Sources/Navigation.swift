//
//  Navigation.swift
//  nimbus-ios-sample
//
//  Created on 5/27/23.
//

import Foundation
import UIKit
import Nimbus

protocol NavigationItem: CaseIterable, CustomStringConvertible {
    var rawValue: String { get }
    
    func destinationController(parent: String) -> UIViewController
}

extension RawRepresentable where RawValue == String, Self: NavigationItem {
    var description: String { rawValue }
}

struct Section {
    let header: String?
    let items: [any NavigationItem]
}

public var mainScreen: () -> UIViewController = MainItem.viewController

enum MainItem: String, NavigationItem {
    case showAdDemo         = "Show Ad Demo"
    case mediationPlatforms = "Mediation Platforms"
    case thirdPartyDemand   = "Third Party Demand"
    case testRender         = "Test Render"
    case settings           = "Settings"
    
    static let title = "Integration Assist".uppercased()
    static let subtitle = "Ad Call Demos and Render Testing"
    static let viewController = {
        NavigationListViewController(
            title: MainItem.title,
            subtitle: MainItem.subtitle,
            items: [Section(header: nil, items: MainItem.allCases)]
        )
    }
   
    func destinationController(parent: String) -> UIViewController {
        switch self {
        case .showAdDemo:
            return NavigationListViewController(
                title: self.description,
                subtitle: "Select to see Nimbus' request and render flow",
                items: [Section(header: nil, items: AdManagerAdType.allCases)])
        case .mediationPlatforms:
            let items: [Section]
            let isGAM = Bundle.main.infoDictionary?["GADIsAdManagerApp"] as? Bool == true
            if isGAM {
                items = [
                    Section(header: "Google Ad Manager (GAM)", items: DynamicPriceNimbusRendering.allCases)
                ]
            } else {
                items = [
                    Section(header: "Set GADIsAdManagerApp to true in your Info.plist to see dynamic price samples", items: [])
                ]
            }
            
            return  NavigationListViewController(
                title: self.description,
                subtitle: "For non-standalone Nimbus integrations",
                items: items
            )
        case .thirdPartyDemand:
            return NavigationListViewController(
                title: self.description,
                subtitle: "Select to see Nimbus' integration with third party demand",
                items: [
                    Section(header: "AdMob", items: AdMob.allCases),
                    Section(header: "MobileFuse", items: MobileFuseSample.allCases),
                    Section(header: "APS", items: APSSample.allCases),
                    Section(header: "Meta Audience Network", items: MetaSample.allCases),
                    Section(header: "Unity", items: UnitySample.allCases),
                    Section(header: "Vungle", items: VungleSample.allCases),
                    Section(header: "Mintegral", items: Mintegral.allCases),
                    Section(header: "Moloco", items: Moloco.allCases),
                    Section(header: "InMobi", items: InMobi.allCases),
                ])
        case .testRender:
            return TestRenderViewController(
                headerTitle: self.description,
                headerSubTitle: "Paste a VAST or HTML Nimbus response"
            )
        case .settings:
            return SettingsViewController(headerTitle: self.description, headerSubTitle: "Configure your test app experience")
        }
    }
}

enum AdManagerAdType: String, NavigationItem {
    case manuallyRenderedAd         = "Manually Rendered Ad"
    case banner                     = "Banner"
    case inlineVideo                = "Inline Video"
    case interstitialHybrid         = "Interstitial Hybrid"
    case interstitialStatic         = "Interstitial Static"
    case interstitialVideo          = "Interstitial Video"
    case rewardedVideo              = "Rewarded Video"
    
    func destinationController(parent: String) -> UIViewController {
        let title = "Nimbus Rendering"
        
        return switch self {
        case .banner:
            BannerViewController(headerTitle: title, headerSubTitle: rawValue, enabledExtension: nil)
        case .inlineVideo:
            InlineVideoViewController(headerTitle: title, headerSubTitle: rawValue, enabledExtension: nil)
        case .manuallyRenderedAd:
            ManuallyRenderedViewController(headerTitle: title, headerSubTitle: rawValue, enabledExtension: nil)
        case .interstitialHybrid:
            InterstitialViewController(headerTitle: title, headerSubTitle: rawValue, enabledExtension: nil)
        case .interstitialStatic:
            CustomInterstitialViewController(headerTitle: title, kind: .staticOnly)
        case .interstitialVideo:
            CustomInterstitialViewController(headerTitle: title, kind: .videoOnly)
        case .rewardedVideo:
            RewardedViewController(
                headerTitle: "Nimbus Rendering",
                headerSubTitle: rawValue,
                enabledExtension: nil
            )
        }
    }
}

enum DynamicPriceNimbusRendering: String, NavigationItem {
    case banner = "Banner"
    case adLoaderBanner = "AdLoader Banner"
    case inlineVideo = "Inline Video"
    case interstitial = "Interstitial"
    case rewarded = "Rewarded"
    case rewardedInterstitial = "Rewarded Interstitial"
    
    func destinationController(parent: String) -> UIViewController {
        let title = "Dynamic Price Nimbus Rendering"
        
        switch self {
        case .banner: return GAMBannerViewController(headerTitle: title, headerSubTitle: "Banner")
        case .adLoaderBanner: return GAMAdLoaderBannerViewController(headerTitle: title, headerSubTitle: "AdLoader Banner")
        case .inlineVideo: return GAMInlineVideoViewController(headerTitle: title, headerSubTitle: "Inline Video")
        case .interstitial: return GAMInterstitialViewController(headerTitle: title, headerSubTitle: "Interstitial")
        case .rewarded: return GAMRewardedViewController(headerTitle: title, headerSubTitle: "Rewarded")
        case .rewardedInterstitial: return GAMRewardedInterstitialViewController(headerTitle: title, headerSubTitle: "Rewarded Interstitial")
        }
    }
}

enum Mintegral: String, NavigationItem {
    case banner                 = "Banner"
    case native                 = "Native"
    case interstitial           = "Interstitial"
    case rewarded               = "Rewarded Video"
    
    func destinationController(parent: String) -> UIViewController {
        return switch self {
        case .banner: MintegralBannerViewController(headerTitle: "Mintegral Banner", headerSubTitle: "")
        case .native: MintegralNativeViewController(headerTitle: "Mintegral Native", headerSubTitle: "")
        case .interstitial: MintegralInterstitialViewController(headerTitle: "Mintegral Interstitial", headerSubTitle: "")
        case .rewarded: MintegralRewardedViewController(headerTitle: "Mintegral Rewarded", headerSubTitle: "")
        }
    }
}

enum Moloco: String, NavigationItem {
    case banner                 = "Banner"
    case native                 = "Native"
    case interstitial           = "Interstitial"
    case rewarded               = "Rewarded Video"
    
    func destinationController(parent: String) -> UIViewController {
        return switch self {
        case .banner: MolocoBannerViewController(headerTitle: "Moloco Banner", headerSubTitle: "")
        case .native: MolocoNativeViewController(headerTitle: "Moloco Native", headerSubTitle: "")
        case .interstitial: MolocoInterstitialViewController(headerTitle: "Moloco Interstitial", headerSubTitle: "")
        case .rewarded: MolocoRewardedViewController(headerTitle: "Moloco Rewarded", headerSubTitle: "")
        }
    }
}

enum InMobi: String, NavigationItem {
    case banner                 = "Banner"
    case interstitial           = "Interstitial"
    case rewarded               = "Rewarded Video"
    
    func destinationController(parent: String) -> UIViewController {
        return switch self {
        case .banner: InMobiBannerViewController(headerTitle: "InMobi Banner", headerSubTitle: "")
        case .interstitial: InMobiInterstitialViewController(headerTitle: "InMobi Interstitial", headerSubTitle: "")
        case .rewarded: InMobiRewardedViewController(headerTitle: "InMobi Rewarded", headerSubTitle: "")
        }
    }
}

enum AdMob: String, NavigationItem {
    case banner                 = "Banner"
    case native                 = "Native Ad"
    case interstitial           = "Interstitial"
    case rewarded               = "Rewarded Video"
    
    func destinationController(parent: String) -> UIViewController {
        return switch self {
        case .banner: AdMobBannerViewController(headerTitle: "AdMob Banner", headerSubTitle: "")
        case .native: AdMobNativeViewController(headerTitle: "AdMob Native Ad", headerSubTitle: "")
        case .interstitial: AdMobInterstitialViewController(headerTitle: "AdMob Interstitial", headerSubTitle: "")
        case .rewarded: AdMobRewardedViewController(headerTitle: "AdMob Rewarded", headerSubTitle: "")
        }
    }
}

enum MobileFuseSample: String, NavigationItem {
    case mobileFuseBanner = "MobileFuse - Banner"
    case mobileFuseMREC = "MobileFuse - MREC"
    case mobileFuseInterstitial = "MobileFuse - Interstitial"
    case mobileFuseRewarded = "MobileFuse - Rewarded"
    
    func destinationController(parent: String) -> UIViewController {
        switch self {
        case .mobileFuseBanner: 
            MobileFuseBannerViewController(
                headerTitle: rawValue,
                position: "MobileFuse_Testing_Display_iOS_Nimbus",
                size: .banner
            )
        case .mobileFuseMREC:
            MobileFuseBannerViewController(
                headerTitle: rawValue,
                position: "MobileFuse_Testing_MREC_iOS_Nimbus",
                size: .mrec
            )
        case .mobileFuseInterstitial: MobileFuseInterstitialViewController(headerTitle: rawValue)
        case .mobileFuseRewarded: MobileFuseRewardedViewController(headerTitle: rawValue)
        }
    }
}

enum APSSample: String, NavigationItem {
    case apsBannerWithRefresh   = "Refreshing Banner"
    case apsInterstitialHybrid  = "Interstitial Hybrid"
    func destinationController(parent: String) -> UIViewController {
        return switch self {
        case .apsBannerWithRefresh:
            APSBannerViewController(headerTitle: "APS", headerSubTitle: rawValue, enabledExtension: nil)
        case .apsInterstitialHybrid:
            APSInterstitialViewController(headerTitle: "APS", headerSubTitle: rawValue, enabledExtension: nil)
        }
    }
}

enum MetaSample: String, NavigationItem {
    case metaBanner             = "Meta Banner"
    case metaInterstitial       = "Meta Interstitial"
    case metaNative             = "Meta Native"
    case metaRewardedVideo      = "Meta Rewarded Video"
    func destinationController(parent: String) -> UIViewController {
        FANViewController(adType: self, headerSubTitle: parent)
    }
}

enum UnitySample: String, NavigationItem {
    case unityRewardedVideo     = "Unity Rewarded Video"
    func destinationController(parent: String) -> UIViewController {
        UnityViewController(adType: self, headerSubTitle: parent)
    }
}

enum VungleSample: String, NavigationItem {
    case vungleBanner           = "Vungle Banner"
    case vungleMREC             = "Vungle MREC"
    case vungleInterstitial     = "Vungle Interstitial"
    case vungleRewarded         = "Vungle Rewarded"
    case vungleNative           = "Vungle Native"
    
    func destinationController(parent: String) -> UIViewController {
        VungleViewController(adType: self, headerSubTitle: parent)
    }
}
                                                
final class NavigationListViewController: DemoViewController, UITableViewDelegate, UITableViewDataSource {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.sectionHeaderTopPadding = 0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 75
        tableView.separatorInset = .zero
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerCell(DemoCell.self)
        tableView.registerHeaderFooter(DemoHeader.self)
        return tableView
    }()
    
    let dataSource: [Section]
    
    init(title: String, subtitle: String, items: [Section]) {
        dataSource = items
        super.init(headerTitle: title, headerSubTitle: subtitle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if headerTitle == "Integration Assist".uppercased() {
            titleLabel.font = .proximaNova(size: 23, weight: .semibold)
            titleLabel.setTextSpacingBy(value: 1.92)
            titleLabel.textAlignment = .center
            
            subTitleLabel.textAlignment = .center
        }
        setupScrollView(tableView)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DemoCell = tableView.dequeueReusableCell(for: indexPath)
        cell.label.text = dataSource[indexPath.section].items[indexPath.row].description
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header: DemoHeader = tableView.dequeueReusableHeaderFooterView()
        header.label.text = dataSource[section].header
        header.label.lineBreakMode = .byWordWrapping
        header.label.numberOfLines = 0
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(
            dataSource[indexPath.section].items[indexPath.row].destinationController(parent: headerTitle),
            animated: true
        )
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        dataSource[section].header != nil ? DemoHeader.height : 0
    }
}
