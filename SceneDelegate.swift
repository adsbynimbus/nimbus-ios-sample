//
//  SceneDelegate.swift
//  nimbus-ios-sample
//
//  Created by Jason Sznol on 5/29/23.
//

import Application
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = DemoNavigationController(rootViewController: mainScreen())
        window?.makeKeyAndVisible()
    }
}
