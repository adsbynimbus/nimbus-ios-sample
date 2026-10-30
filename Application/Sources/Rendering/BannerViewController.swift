//
//  BannerViewController.swift
//  Nimbus
//  Created on 9/2/25
//  Copyright © 2025 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import NimbusKit

final class BannerViewController: SampleAdViewController {
    var bannerAd: InlineAd?
    let contentView = UIView()
    let size: AdSize
    
    init(headerTitle: String, headerSubTitle: String, size: AdSize) {
        self.size = size
        super.init(headerTitle: headerTitle, headerSubTitle: headerSubTitle, requiredExtension: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentView)
        
        let format = size == .banner ? RTB.Format.banner : RTB.Format.mrec
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: Constants.headerOffset),
            contentView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            contentView.widthAnchor.constraint(equalToConstant: CGFloat(format.width)),
            contentView.heightAnchor.constraint(equalToConstant: CGFloat(format.height)),
        ])
        
        Task { await showAd() }
    }
    
    func showAd() async {
        do {
            bannerAd = try await Nimbus.bannerAd(position: "banner", size: size, refreshInterval: 30)
                .onEvent { [weak self] event in
                    self?.didReceiveNimbusEvent(event: event, ad: self?.bannerAd)
                }
                .onError { [weak self] error in
                    self?.didReceiveNimbusError(error: error)
                }
                .show(in: contentView)
        } catch {
            print("Couldn't show ad: \(error)")
        }
    }
}
