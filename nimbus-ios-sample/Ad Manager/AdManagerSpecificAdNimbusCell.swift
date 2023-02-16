//
//  AdManagerSpecificAdNimbusCell.swift
//  NimbusInternalSampleApp
//
//  Created by Inder Dhir on 6/10/22.
//  Copyright © 2022 Timehop. All rights reserved.
//

import UIKit
import NimbusKit

final class AdManagerSpecificAdNimbusCell: UICollectionViewCell {
    
    private let adManager = NimbusAdManager()
    private var adController: AdController?

    func requestNimbusAd(_ request: NimbusRequest, with vc: UIViewController) {
        adManager.delegate = self
        adManager.showAd(
            request: request,
            container: contentView,
            adPresentingViewController: vc
        )
    }
    
    deinit {
        adController?.destroy()
    }
    
}

extension AdManagerSpecificAdNimbusCell: NimbusAdManagerDelegate {
    
    func didRenderAd(request: NimbusRequest, ad: NimbusAd, controller: AdController) {
        print("didRenderAd")
        self.adController = controller
    }
    
    func didCompleteNimbusRequest(request: NimbusRequest, ad: NimbusAd) {
        print("didCompleteNimbusRequest")
    }
    
    func didFailNimbusRequest(request: NimbusRequest, error: NimbusError) {
        print("didFailNimbusRequest")
    }
    
    
}
