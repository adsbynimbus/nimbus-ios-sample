//
//  MainViewController.swift
//  nimbus-ios-sample
//
//  Created by Victor Takai on 08/11/21.
//

import UIKit

final class MainViewController: DemoViewController {
    override var headerTitle: String {
        "Integration Assist".uppercased()
    }
    
    override var headerSubTitle: String {
        "Ad Call Demos and Render Testing"
    }
        
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 75
        tableView.separatorInset = .zero
        tableView.registerCell(DemoCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.accessibilityIdentifier = "mainTableView"
        return tableView
    }()
    
    private var dataSource: [MainItem] { MainItem.allCases }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTitleLabel()
        setupSubTitleLabel()
        setupScrollView(tableView)
    }
    
    private func setupTitleLabel() {
        titleLabel.font = .proximaNova(size: 23, weight: .semibold)
        titleLabel.setTextSpacingBy(value: 1.92)
        titleLabel.textAlignment = .center
    }
    
    private func setupSubTitleLabel() {
        subTitleLabel.textAlignment = .center
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DemoCell = tableView.dequeueReusableCell(for: indexPath)
        let item = dataSource[indexPath.row]
        cell.updateWithMainItem(item)
        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menuItem = dataSource[indexPath.row]
        let viewController: DemoViewController
        
        switch menuItem {
        case .showAdDemo:
            viewController = AdDemoViewController()
        case .mediationPlatforms:
            viewController = MediationViewController()
        case .thirdPartyDemand:
            break
        case .testRender:
            viewController = TestRenderViewController()
        case .settings:
            viewController = SettingsViewController()
        }
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}
