//
//  DemoNavigationController.swift
//  nimbus-ios-sample
//
//  Created by Victor Takai on 09/11/21.
//

import UIKit

public final class DemoNavigationController: UINavigationController {
    
    let backArrow = UIImage(named: "left-arrow")?.imageWithInset(inset: 2)
    let appearance = UINavigationBarAppearance()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .raisingBlack
        appearance.shadowColor = .clear
        appearance.backButtonAppearance.normal.titleTextAttributes = [
            .font: UIFont.proximaNova(size: 18, weight: .regular),
            .foregroundColor: UIColor.white
        ]
        appearance.setBackIndicatorImage(backArrow, transitionMaskImage: backArrow)

        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.prefersLargeTitles = false
        navigationBar.tintColor = .white
    }
}
