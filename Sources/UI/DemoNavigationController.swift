//
//  DemoNavigationController.swift
//  nimbus-ios-sample
//
//  Created by Victor Takai on 09/11/21.
//

import UIKit

final class DemoNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        let image = UIImage(named: "left-arrow")?.imageWithInset(inset: 2)
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .raisingBlack
        appearance.shadowColor = .clear
        appearance.backButtonAppearance.normal.titleTextAttributes = [
            .font: UIFont.proximaNova(size: 18, weight: .regular),
            .foregroundColor: UIColor.white
        ]
        appearance.setBackIndicatorImage(image, transitionMaskImage: image)

        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.prefersLargeTitles = false
        navigationBar.tintColor = .white
    }
}
