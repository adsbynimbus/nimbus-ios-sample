//
//  AdManagerViewController.swift
//  nimbus-ios-sample
//
//  Created on 11/11/21.
//

import NimbusCoreKit
import NimbusKit
import UIKit
import SwiftUI

// TODO: Split out by ad type like Moloco for instance
final class AdManagerViewController: SampleAdViewController {
    private let contentView = UIView()
    private var inlineAd: InlineAd?
    private var interstitialAd: InterstitialAd?
    private var rewardedAd: RewardedAd?
    
    private let adType: AdManagerAdType
    private var hasCompanionAd = false
    
    init(adType: AdManagerAdType, headerSubTitle: String) {
        self.adType = adType
        super.init(headerTitle: adType.description, headerSubTitle: headerSubTitle, enabledExtension: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupContentView()
        
        Task {
            do {
                try await setupAdRendering()
            } catch {
                print("Couldn't show ad: \(error)")
            }
        }
    }
    
    private func setupContentView() {
        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: Constants.headerOffset),
            contentView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            contentView.widthAnchor.constraint(greaterThanOrEqualToConstant: 320),
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),
        ])
    }
    
    private func setupAdRendering() async throws {
        
        switch adType {
        case .manuallyRenderedAd:
            inlineAd = try await Nimbus.bannerAd(position: adType.description).fetch().show(in: contentView)
        case .banner:
            inlineAd = try await Nimbus.bannerAd(position: adType.description).show(in: contentView)
        case .bannerWithRefresh:
            inlineAd = try await Nimbus.bannerAd(position: adType.description, refreshInterval: 30).show(in: contentView)
        case .inlineVideo:
            if UIDevice.nimbusIsLandscape {
                NSLayoutConstraint.activate([
                    contentView.widthAnchor.constraint(equalToConstant: CGFloat(NimbusAdDimensions.landscapeInlineAd.width)),
                    contentView.heightAnchor.constraint(equalToConstant: CGFloat(NimbusAdDimensions.landscapeInlineAd.height)),
                ])
            } else {
                NSLayoutConstraint.activate([
                    contentView.widthAnchor.constraint(equalToConstant: CGFloat(NimbusAdDimensions.portraitInlineAd.width)),
                    contentView.heightAnchor.constraint(equalToConstant: CGFloat(NimbusAdDimensions.portraitInlineAd.height)),
                ])
            }

            inlineAd = try await Nimbus.inlineAd(position: adType.description) {
                video()
            }
            .show(in: contentView)
        case .interstitialHybrid:
            interstitialAd = try await Nimbus.interstitialAd(position: adType.description).show(in: self)
        case .interstitialStatic:
            interstitialAd = try await Nimbus.fullscreenAd(position: adType.description) {
                banner(size: .interstitial)
            }
            .show(in: self, closeButtonDelay: 0)
        case .interstitialVideo, .interstitialVideoWithoutUI:
            interstitialAd = try await Nimbus.fullscreenAd(position: adType.description) {
                video()
            }
            .show(in: self, closeButtonDelay: 0)
        case .rewardedVideo:
            rewardedAd = try await Nimbus.rewardedAd(position: adType.description).show(in: self)
        }
    }
    
    override func didReceiveNimbusEvent(controller: AdController, event: NimbusEvent) {
        super.didReceiveNimbusEvent(controller: controller, event: event)
        
        switch event {
        case .loaded:
            controller.adView?.makeWebViewInspectable()
        case .loadedCompanionAd:
            hasCompanionAd = true
        case .completed:
            if hasCompanionAd {
                // Ensures companion ad view is present
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    if let companionAdView = controller.adView?.subviews.last {
                        companionAdView.makeWebViewInspectable()
                    }
                }
            }
        default:
            break
        }
    }
}
