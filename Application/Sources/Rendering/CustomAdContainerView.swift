//
//  AdView.swift
//  nimbus-ios-sample
//
//  Created by Victor Takai on 19/11/21.
//

import UIKit
import NimbusKit
import NimbusRenderStaticKit

final class CustomAdContainerView: UIView, AdControllerDelegate {

    private let ad: NimbusAd
    private let volume: Int
    private let companionAd: NimbusCompanionAd?
    private let viewController: UIViewController
    private let creativeScalingEnabledForStaticAds: Bool
    private let staticAdRenderer = Nimbus.shared.renderers.first(where: { $0.key == .forAuctionType(.static) })?.value
           as? NimbusStaticAdRenderer
    private lazy var nimbusAdView = NimbusAdView(adPresentingViewController: viewController)
    private weak var delegate: AdControllerDelegate?
    
    init(
        ad: NimbusAd,
        volume: Int = 0,
        companionAd: NimbusCompanionAd? = nil,
        viewController: UIViewController,
        creativeScalingEnabledForStaticAds: Bool = true,
        delegate: AdControllerDelegate? = nil
    ) {
        self.ad = ad
        self.volume = volume
        self.companionAd = companionAd
        self.viewController = viewController
        self.creativeScalingEnabledForStaticAds = creativeScalingEnabledForStaticAds
        self.delegate = delegate
        
        super.init(frame: .zero)

        staticAdRenderer?.creativeScalingEnabled = creativeScalingEnabledForStaticAds
        setupAdView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func destroy() {
        nimbusAdView.destroy()
        staticAdRenderer?.creativeScalingEnabled = true
    }
    
    private func setupAdView() {
        addSubview(nimbusAdView)
        nimbusAdView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nimbusAdView.topAnchor.constraint(equalTo: topAnchor),
            nimbusAdView.bottomAnchor.constraint(equalTo: bottomAnchor),
            nimbusAdView.leadingAnchor.constraint(equalTo: leadingAnchor),
            nimbusAdView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        nimbusAdView.volume = volume
        nimbusAdView.delegate = self
        
        nimbusAdView.render(ad: ad, companionAd: companionAd)
        nimbusAdView.start()
    }
    
    func didReceiveNimbusEvent(controller: AdController, event: NimbusEvent) {
        delegate?.didReceiveNimbusEvent(controller: controller, event: event)
    }
    
    func didReceiveNimbusError(controller: AdController, error: NimbusError) {
        delegate?.didReceiveNimbusError(controller: controller, error: error)
    }
}
