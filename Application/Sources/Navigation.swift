//
//  Navigation.swift
//  nimbus-ios-sample
//
//  Created by Jason Sznol on 5/27/23.
//

import Foundation
import UIKit

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
            let isAdMob = Bundle.main.infoDictionary?["GADIsAdManagerApp"] as? Int == 0
            if isAdMob {
                items = [Section(header: "AdMob", items: DynamicAdMob.allCases)]
            } else {
                items = [
                    Section(header: "Google Ad Manager", items: GAMMediationAdType.allCases),
                    Section(header: nil, items: DynamicPriceGAM.allCases)
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
                    Section(header: "APS", items: APSSample.allCases),
                    Section(header: "Meta Audience Network", items: MetaSample.allCases),
                    Section(header: "Unity", items: UnitySample.allCases),
                    Section(header: "Vungle", items: VungleSample.allCases)
                ])
        case .testRender:
            return TestRenderViewController(
                headerTitle: self.description,
                headerSubTitle: "Paste in a VAST or HTML Nimbus response"
            )
        case .settings:
            return SettingsViewController(headerTitle: self.description, headerSubTitle: "Configure your test app experience")
        }
    }
}

enum AdManagerAdType: String, NavigationItem {
    case manuallyRenderedAd         = "Manually Rendered Ad"
    case banner                     = "Banner"
    case bannerWithRefresh          = "Banner With Refresh"
    case inlineVideo                = "Inline Video"
    case interstitialHybrid         = "Interstitial Hybrid"
    case interstitialStatic         = "Interstitial Static"
    case interstitialVideo          = "Interstitial Video"
    case interstitialVideoWithoutUI = "Interstitial Video Without UI"
    case rewardedVideo              = "Rewarded Video"
    
    func destinationController(parent: String) -> UIViewController {
        AdManagerViewController(adType: self, headerSubTitle: parent)
    }
}

enum GAMMediationAdType: String, NavigationItem {
    case banner                   = "Banner"
    case interstitial             = "Interstitial"
    
    func destinationController(parent: String) -> UIViewController {
        GAMViewController(adType: self, headerSubTitle: parent)
    }
}

enum DynamicPriceGAM: String, NavigationItem {
    case dynamicPriceBanner       = "Dynamic Price Banner"
    case dynamicPriceBannerVideo  = "Dynamic Price Banner + Video"
    case dynamicPriceInlineVideo  = "Dynamic Price Inline Video"
    case dynamicPriceInterstitial = "Dynamic Price Interstitial"
    func destinationController(parent: String) -> UIViewController {
        GoogleDynamicPriceViewController(adType: self, headerSubTitle: parent)
    }
}

enum DynamicAdMob: String, NavigationItem {
    case dynamicBanner                 = "Dynamic Banner"
    case dynamicInterstitial           = "Dynamic Interstitial"
    case dynamicRewarded               = "Dynamic Rewarded"
    case dynamicRewardedInterstitial   = "Dynamic Rewarded Interstitial"
    func destinationController(parent: String) -> UIViewController {
        AdMobViewController(adType: self, headerSubTitle: parent)
    }
}

enum APSSample: String, NavigationItem {
    case apsBannerWithRefresh   = "APS Banner With Refresh"
    case apsInterstitialHybrid  = "APS Interstitial Hybrid"
    func destinationController(parent: String) -> UIViewController {
        APSViewController(adType: self, headerSubTitle: parent)
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
