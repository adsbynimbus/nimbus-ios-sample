//
//  DemoViewController.swift
//  nimbus-ios-sample
//
//  Created by Victor Takai on 09/11/21.
//

import UIKit

class DemoViewController: UIViewController {
    private(set) var headerTitle: String = ""
    private(set) var headerSubTitle: String = ""
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .proximaNova(size: 20, weight: .bold)
        label.text = headerTitle
        label.textAlignment = .left
        label.textColor = .white
        label.backgroundColor = .raisingBlack
        
        return label
    }()
    
    lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .proximaNova(size: 15)
        label.text = headerSubTitle
        label.textAlignment = .left
        label.textColor = .white
        label.backgroundColor = .raisingBlack
        
        return label
    }()
    
    lazy var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .raisingBlack
        view.addSubview(titleLabel)
        view.addSubview(subTitleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
        ])
        
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            subTitleLabel.bottomAnchor.constraint(greaterThanOrEqualTo: view.bottomAnchor, constant: -20),
            subTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            subTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15)
        ])
        
        return view
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    init(headerTitle: String, headerSubTitle: String) {
        self.headerTitle = headerTitle
        self.headerSubTitle = headerSubTitle
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupLogo()
        setupHeaderView()
    }
    
    private func setupHeaderView() {
        view.addSubview(headerView)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    func setupScrollView(_ tableView: UIScrollView) {
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
