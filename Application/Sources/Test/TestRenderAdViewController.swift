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
    
    private lazy var adContainerView: CustomAdContainerView = {
        return CustomAdContainerView(ad: ad, viewController: self)
    }()
    
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
            Nimbus.shared.logger.log("\(#file) failed to render blocking ad, error: \(error)", level: .error)
        }
        
        return nil
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
}
