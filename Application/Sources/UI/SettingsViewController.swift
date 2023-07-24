//
//  SettingsViewController.swift
//  nimbus-ios-sample
//
//  Created by Victor Takai on 10/11/21.
//

import UIKit

final class SettingsViewController: DemoViewController {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.sectionHeaderTopPadding = 0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 75
        tableView.separatorInset = .zero
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerCell(SettingsCell.self)
        tableView.registerHeaderFooter(DemoHeader.self)
        return tableView
    }()
    
    private let sections: [SettingsEnum.Type] = [GeneralSettings.self, UserDetailsSettings.self]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScrollView(tableView)
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SettingsCell = tableView.dequeueReusableCell(for: indexPath)
        
        let setting = sections[indexPath.section].allCases[indexPath.row]
        cell.label.text = setting.rawValue
        cell.switchButton.setOn(setting.isEnabled, animated: false)
        cell.switchAction = { isOn in setting.update(isEnabled: isOn) }

        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let header: DemoHeader = tableView.dequeueReusableHeaderFooterView()
            header.label.text = "User Details"
            return header
        } else {
            return nil
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        section == 1 ? DemoHeader.height : 0
    }
}
