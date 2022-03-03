//
//  MediationViewController.swift
//  nimbus-ios-sample
//
//  Created by Victor Takai on 15/11/21.
//

import UIKit

final class MediationViewController: DemoViewController {
    override var headerTitle: String {
        "Mediation Platforms"
    }
    
    override var headerSubTitle: String {
        "For non-standalone Nimbus integrations"
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
        tableView.accessibilityIdentifier = "mediationTableView"
        return tableView
    }()
    
    private var dataSource: [DemoDataSource<MediationIntegrationType, MediationAdType>] {
        [
            DemoDataSource(type: .google, values: MediationAdType.allCases),
            DemoDataSource(type: .moPub, values: MediationAdType.allCases)
        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScrollView(tableView)
    }
    
    private func showController(
        integrationType: MediationIntegrationType,
        adType: MediationAdType
    ) {
        
        switch integrationType {
        case .google:
            if adType == .banner
                && ConfigManager.shared.googleBannerId.isEmptyOrNil {
                showCustomAlert("google_banner_id")
            } else if adType == .dynamicPriceBanner
                        && ConfigManager.shared.googleDynamicPriceBannerId.isEmptyOrNil {
                showCustomAlert("google_dynamic_price_banner_id")
            } else if adType == .interstitial
                        && ConfigManager.shared.googleInterstitialId.isEmptyOrNil {
                showCustomAlert("google_interstitial_id")
            } else if adType == .dynamicPriceInterstitial
                        && ConfigManager.shared.googleDynamicPriceInterstitialId.isEmptyOrNil {
                showCustomAlert("google_dynamic_price_interstitial_id")
            } else {
                navigationController?.pushViewController(
                    GoogleViewController(
                        adType: adType,
                        headerSubTitle: integrationType.description + " - " + headerTitle
                    ),
                    animated: true
                )
            }
        case .moPub:
            if (adType == .banner || adType == .dynamicPriceBanner)
                && ConfigManager.shared.mopubBannerId.isEmptyOrNil {
                showCustomAlert("mopub_banner_id")
            } else if (adType == .interstitial || adType == .dynamicPriceInterstitial)
                        && ConfigManager.shared.mopubInterstitialId.isEmptyOrNil {
                showCustomAlert("mopub_interstitial_id")
            } else {
                navigationController?.pushViewController(
                    MopubViewController(
                        adType: adType,
                        headerSubTitle: integrationType.description + " - " + headerTitle
                    ),
                    animated: true
                )
            }
        }
    }
}

extension MediationViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource[section].values.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DemoCell = tableView.dequeueReusableCell(for: indexPath)
        let adType = dataSource[indexPath.section].values[indexPath.row]
        
        cell.updateWithMediationAdType(adType)
        return cell
    }
}

extension MediationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header: DemoHeader = tableView.dequeueReusableHeaderFooterView()
        let integrationType = dataSource[section].type
        header.updateWithMediationIntegrationType(integrationType)
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
