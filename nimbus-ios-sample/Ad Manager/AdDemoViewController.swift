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
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScrollView(tableView)
    }
}

extension AdDemoViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int { 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        AdManagerAdType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DemoCell = tableView.dequeueReusableCell(for: indexPath)
        let adType = AdManagerAdType.allCases[indexPath.row]
        cell.updateWithAdManagerAdType(adType)
        return cell
    }
}

extension AdDemoViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let adType = AdManagerAdType.allCases[indexPath.row]
        let shouldShowVideoUI = adType == .interstitialVideoWithoutUI
        
        navigationController?.pushViewController(
            AdManagerViewController(
                adType: adType,
                headerSubTitle: headerTitle,
                shouldShowVideoUI: shouldShowVideoUI
            ),
            animated: true
        )
    }
}
