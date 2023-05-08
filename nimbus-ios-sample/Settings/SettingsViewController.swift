//
//  SettingsViewController.swift
//  nimbus-ios-sample
//
//  Created by Victor Takai on 10/11/21.
//

import UIKit

final class SettingsViewController: DemoViewController {
    override var headerTitle: String { "Settings" }
    
    override var headerSubTitle: String {
        "Configure your test app experience"
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.sectionHeaderTopPadding = 0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 75
        tableView.separatorInset = .zero
        tableView.registerCell(SettingsCell.self)
        tableView.registerHeaderFooter(DemoHeader.self)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private var dataSource: [DemoDataSource<SettingsSection, Setting>] {
        [
            DemoDataSource(
                type: .main,
                values: Setting.allCases.filter { !$0.isUserPrivacySetting }
            ),
            DemoDataSource(
                type: .userDetails,
                values: [Setting.gdprConsent, Setting.ccpaConsent]
            )
        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScrollView(tableView)
    }
}

extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource[section].values.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SettingsCell = tableView.dequeueReusableCell(for: indexPath)
        let setting = dataSource[indexPath.section].values[indexPath.row]
        cell.updateWithSetting(setting)
        return cell
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let settingsSection = dataSource[section].type
        if settingsSection == .userDetails {
            let header: DemoHeader = tableView.dequeueReusableHeaderFooterView()
            header.updateWithSection(settingsSection)
            return header
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        dataSource[section].type == .userDetails ? DemoHeader.height : 0
    }
}
