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
    
    let adManager = NimbusAdManager()

    func requestNimbusAd(_ request: NimbusRequest, with vc: UIViewController) {        
        adManager.showAd(
            request: request,
            container: contentView,
            adPresentingViewController: vc
        )
    }
}
