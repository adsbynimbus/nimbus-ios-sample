//
//  TestRenderAdViewController.swift
//  nimbus-ios-sample
//
//  Created on 22/11/21.
//

import UIKit
import NimbusKit

final class TestRenderAdViewController: UIViewController {
    private let response: NimbusResponse
    private var ad: InlineAd?
    
    init(response: NimbusResponse) {
        self.response = response
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        Task {
            ad = try await Nimbus.inlineAd(from: response).show(in: view)
            (ad?.adView as? NimbusAdView)?.showsSKOverlay = true

            setupLogo()
            setup(adView: ad?.adView)
        }
    }
    
    private func setup(adView: UIView?) {
        guard let adView else { return }
        view.layout(adView) { child in
            child.alignTop()
            child.fill()
        }
    }
}
