//
//  TestRenderAdViewController.swift
//  nimbus-ios-sample
//
//  Created on 22/11/21.
//

import UIKit
import NimbusKit

final class TestRenderAdViewController: UIViewController {
    private let ad: NimbusAd
    
    init(ad: NimbusAd) {
        self.ad = ad
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func showBlocking(from: UIViewController, ad: NimbusAd) -> AdController? {
        do {
            return try Nimbus.loadBlocking(
                ad: ad,
                presentingViewController: from,
                delegate: nil,
                isRewarded: false
            )
        } catch {
            print("\(#file) failed to render blocking ad, error: \(error)")
        }
        
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        let adController = try! Nimbus.load(
            ad: ad,
            container: view,
            adPresentingViewController: self,
            delegate: nil,
            showsSKOverlay: true
        )

        setupLogo()
        setup(adView: adController.adView)
    }
    
    private func setup(adView: UIView?) {
        guard let adView else { return }
        view.layout(adView) { child in
            child.alignTop()
            child.fill()
        }
    }
}
