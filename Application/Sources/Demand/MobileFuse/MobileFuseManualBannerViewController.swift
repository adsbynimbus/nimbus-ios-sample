//
//  MobileFuseManualBannerViewController.swift
//  NimbusInternalSampleApp
//
//  Created on 9/18/23.
//  Copyright © 2023 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import NimbusKit

final class MobileFuseManualBannerViewController: MobileFuseViewController {
    private let requestManager = NimbusRequestManager()
    private lazy var nimbusAdView = NimbusAdView(adPresentingViewController: self)
    
    enum State {
        case notLoaded
        case requestCompleted
        case adLoaded
    }
    
    private var state = State.notLoaded
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Load Mobile Fuse Ad", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        actionButton.addTarget(self, action: #selector(onShowAd), for: .touchUpInside)
        view.addSubview(actionButton)
        NSLayoutConstraint.activate([
            actionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            actionButton.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 8)
        ])        
        
        requestManager.delegate = self
        requestManager.performRequest(request: NimbusRequest.forBannerAd(position: "MobileFuse_Testing_MREC_iOS_Nimbus", format: .letterbox))
    }
    
    private func setupAdView() {
        guard let ad = nimbusAd else { return }
        
        view.addSubview(nimbusAdView)
        nimbusAdView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nimbusAdView.topAnchor.constraint(equalTo: actionButton.bottomAnchor, constant: 16),
            nimbusAdView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            nimbusAdView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nimbusAdView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        nimbusAdView.delegate = self

        nimbusAdView.render(ad: ad, companionAd: nil)
    }
    
    @objc private func onShowAd() {
        if state == .requestCompleted {
            setupAdView()
            actionButton.setTitle("Start ad", for: .normal)
        } else if state == .adLoaded {
            nimbusAdView.start()
        }
        
        actionButton.isEnabled = false
    }
    
    override func didReceiveNimbusEvent(controller: AdController, event: NimbusEvent) {
        super.didReceiveNimbusEvent(controller: controller, event: event)
        
        if event == .loaded {
            state = .adLoaded
            actionButton.isEnabled = true
        }
    }
}

extension MobileFuseManualBannerViewController: NimbusRequestManagerDelegate {
    func didCompleteNimbusRequest(request: NimbusRequest, ad: NimbusAd) {
        print("didCompleteNimbusRequest")
        state = .requestCompleted
        actionButton.isEnabled = true
        nimbusAd = ad
    }
    
    func didFailNimbusRequest(request: NimbusRequest, error: NimbusError) {
        print("didFailNimbusRequest: \(error.localizedDescription)")
    }
}
