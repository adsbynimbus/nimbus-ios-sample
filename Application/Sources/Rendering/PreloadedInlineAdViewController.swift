//
//  PreloadedInlineAdViewController.swift
//  Nimbus
//  Created on 7/15/26
//  Copyright © 2026 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import NimbusKit

final class PreloadedInlineAdViewController: SampleAdViewController {
    var bannerAd: InlineAd?
    let loadButton = UIButton(type: .system)
    var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadButton.translatesAutoresizingMaskIntoConstraints = false
        loadButton.setTitle("Load Ad", for: .normal)
        loadButton.addTarget(self, action: #selector(loadAd), for: .touchUpInside)
        
        view.addSubview(loadButton)
        
        NSLayoutConstraint.activate([
            loadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadButton.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 50),
            loadButton.widthAnchor.constraint(equalToConstant: 200),
            loadButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        
    }
    
    @objc private func loadAd() {
        guard !isLoading else { return }
        isLoading = true
        
        Task {
            do {
                bannerAd = try await Nimbus.bannerAd(position: "manual-interstitial", size: .banner)
                    .onEvent { event in
                        print("Received Nimbus event: \(event)")
                        
                        if event == .loaded {
                            self.loadButton.setTitle("Show Ad", for: .normal)
                            self.loadButton.removeTarget(self, action: #selector(self.loadAd), for: .touchUpInside)
                            self.loadButton.addTarget(self, action: #selector(self.showAd), for: .touchUpInside)
                            self.isLoading = false
                        }
                    }
                    .onError { error in
                        print("Received Nimbus error: \(error)")
                    }
                    .load()
            } catch {
                print("Couldn't load ad: \(error)")
            }
        }
    }
    
    @objc private func showAd() {
        Task {
            do {
                try await bannerAd?.show(in: view)
            } catch {
                print("Couldn't show ad: \(error)")
            }
        }
    }
}
