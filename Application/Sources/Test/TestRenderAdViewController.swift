//
//  TestRenderAdViewController.swift
//  nimbus-ios-sample
//
//  Created on 22/11/21.
//

import UIKit
import NimbusKit

final class TestRenderAdViewController: UIViewController {
    private let adMarkup: String
    private let iTunesAppId: String?
    
    private lazy var adContainerView: CustomAdContainerView = {
        return CustomAdContainerView(ad: Self.getAdFromMarkup(adMarkup: adMarkup), viewController: self)
    }()
    
    init(adMarkup: String, iTunesAppId: String?) {
        self.adMarkup = adMarkup
        self.iTunesAppId = iTunesAppId
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func showBlocking(from: UIViewController, adMarkup: String, iTunesAppId: String? = nil) {
        let adView = NimbusAdView(adPresentingViewController: from)
        adView.showsSKOverlay = iTunesAppId != nil
        let controller = NimbusAdViewController(adView: adView, ad: getAdFromMarkup(adMarkup: adMarkup, iTunesAppId: iTunesAppId), companionAd: nil)
        controller.modalPresentationStyle = .fullScreen
        
        adView.adPresentingViewController = controller
        adView.isBlocking = true
        
        from.present(controller, animated: true) {
            controller.renderAndStart()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupLogo()
        setupAdView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        adContainerView.destroy()
    }
    
    private func setupAdView() {
        view.layout(adContainerView) { child in
            child.alignTop()
            child.fill()
        }
    }
    
    static private func getAdFromMarkup(adMarkup: String, iTunesAppId: String? = nil) -> NimbusAd {
        let type: NimbusAuctionType = isVideoMarkup(adMarkup: adMarkup) ? .video : .static
        return createNimbusAd(auctionType: type, markup: adMarkup, iTunesAppId: iTunesAppId)
    }
    
    static private func isVideoMarkup(adMarkup: String) -> Bool {
        let prefix = adMarkup.prefix(5).lowercased()
        return prefix == "<vast" || prefix == "<?xml"
    }
    
    static private func createNimbusAd(
        placementId: String? = nil,
        auctionType: NimbusAuctionType,
        markup: String,
        isMraid: Bool = true,
        isInterstitial: Bool = true,
        iTunesAppId: String? = nil
    ) -> NimbusAd {
        let adDimensions = isInterstitial ?
        NimbusAdDimensions(width: 320, height: 480) :
        NimbusAdDimensions(width: 300, height: 50)
        
        let ext = NimbusAdExtensions(skAdNetwork: NimbusAdSkAdNetwork(advertisedAppStoreItemID: iTunesAppId))
        
        return NimbusAd(
            position: "",
            auctionType: auctionType,
            bidRaw: 0,
            bidInCents: 0,
            contentType: "",
            auctionId: "",
            network: "test_render",
            markup: markup,
            isInterstitial: isInterstitial,
            placementId: nil,
            duration: nil,
            adDimensions: adDimensions,
            trackers: nil,
            isMraid: isMraid,
            extensions: iTunesAppId != nil ? ext : nil
        )
    }
}
