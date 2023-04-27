//
//  ThirdPartyDemandViewController.swift
//  nimbus-ios-sample
//
//  Created by Bruno Bruggemann on 20/04/23.
//

import UIKit

final class ThirdPartyDemandViewController: DemoViewController {
    override var headerTitle: String {
        "Third Party Demand"
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
        tableView.accessibilityIdentifier = "thirdPartyDemandTableView"
        return tableView
    }()
    
    private var dataSource: [DemoDataSource<ThirdPartyDemandIntegrationType, MediationAdType>] {
        [DemoDataSource(type: .aps, values: ThirdPartyDemandAdType.apsAdType)]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScrollView(tableView)
    }
    
    private func showController(
        integrationType: MediationIntegrationType,
        adType: MediationAdType
    ) {
        if ConfigManager.shared.googlePlacementId.isEmptyOrNil {
            showCustomAlert("google_placement_id")
        } else {
            navigationController?.pushViewController(
                GAMViewController(
                    adType: adType,
                    headerSubTitle: integrationType.description + " - " + headerTitle
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
        
        cell.updateWithMediationAdType(adType)
        return cell
    }
}

extension ThirdPartyDemandViewController: UITableViewDelegate {
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

