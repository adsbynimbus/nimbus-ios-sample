//
//  UIViewController+Extension.swift
//  nimbus-ios-sample
//
//  Created by Victor Takai on 22/11/21.
//

import UIKit

extension UIViewController {
    func setupLogo() {
        let image = UIImage(named: "logo")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: 145 * 0.8, height: 50 * 0.8)
        navigationItem.titleView = imageView
    }
    
    func showCustomAlert(_ missingKey: String) {
        let alert = UIAlertController(
            title: "Attention",
            message: "\(missingKey) is missing or not set in secrets.json",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
