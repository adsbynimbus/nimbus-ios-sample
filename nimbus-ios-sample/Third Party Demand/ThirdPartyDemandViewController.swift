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
        return tableView
    }()
    
    private var dataSource: [DemoDataSource<ThirdPartyDemandIntegrationType, ThirdPartyDemandAdType>] {
        [
            DemoDataSource(type: .aps, values: ThirdPartyDemandAdType.apsAdTypes),
            DemoDataSource(type: .meta, values: ThirdPartyDemandAdType.metaAdTypes),
            DemoDataSource(type: .unity, values: ThirdPartyDemandAdType.unityAdTypes),
            DemoDataSource(type: .vungle, values: ThirdPartyDemandAdType.vungleAdTypes)
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
        var controller: UIViewController
        switch integrationType {
        case .aps:
            controller = APSViewController(adType: adType, headerSubTitle: headerTitle)
        case .meta:
            controller = FANViewController(adType: adType, headerSubTitle: headerTitle)
        case .unity:
            controller = UnityViewController(adType: adType, headerSubTitle: headerTitle)
        case .vungle:
            controller = VungleViewController(adType: adType, headerSubTitle: headerTitle)
        }
        navigationController?.pushViewController(controller, animated: true)
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
        cell.updateWithThirdPartyDemandAdType(adType)
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
