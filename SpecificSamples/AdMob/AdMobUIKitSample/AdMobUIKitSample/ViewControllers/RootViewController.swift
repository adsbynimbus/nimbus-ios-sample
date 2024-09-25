//
//  RootViewController.swift
//  AdMobUIKitSample
//
//  Created by Standa Musil on 9/19/24.
//

import UIKit

class RootViewController: UITableViewController {
    
    @IBOutlet weak var appIdImageView: UIImageView!
    @IBOutlet weak var bannerAdUnitImageView: UIImageView!
    @IBOutlet weak var nativeAdUnitImageView: UIImageView!
    @IBOutlet weak var interstitialAdUnitImageView: UIImageView!
    @IBOutlet weak var rewardedAdUnitImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setConfig(icon: appIdImageView, isValid: isAppIdValid)
        setConfig(icon: bannerAdUnitImageView, isValid: isAdUnitValid(bannerAdUnitId))
        setConfig(icon: nativeAdUnitImageView, isValid: isAdUnitValid(nativeAdUnitId))
        setConfig(icon: interstitialAdUnitImageView, isValid: isAdUnitValid(interstitialAdUnitId))
        setConfig(icon: rewardedAdUnitImageView, isValid: isAdUnitValid(rewardedAdUnitId))
    }
    
    func setConfig(icon: UIImageView, isValid: Bool) {
        if isValid {
            icon.image = UIImage(systemName: "checkmark")
            icon.tintColor = .init(red: 40/255, green: 205/255, blue: 65/255, alpha: 1)
        } else {
            icon.image = UIImage(systemName: "xmark")
            icon.tintColor = .init(red: 1, green: 59/255, blue: 48/255, alpha: 1)
        }
    }

    var isAppIdValid: Bool {
        adMobAppId != "ca-app-pub-3940256099942544~1458002511"
    }
    
    func isAdUnitValid(_ adUnit: String) -> Bool {
        adUnit.first != "<" && adUnit.last != ">" && !adUnit.isEmpty
    }
}
