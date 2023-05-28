//
//  SceneDelegate.swift
//  nimbus-ios-sample
//
//  Created by Victor Takai on 08/11/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = DemoNavigationController(
            rootViewController: NavigationListViewController(
                title: "Integration Assist".uppercased(),
                subtitle: "Ad Call Demos and Render Testing",
                items: [Section(header: nil, items: MainItem.allCases)]
        ))
        window?.makeKeyAndVisible()
    }
}
