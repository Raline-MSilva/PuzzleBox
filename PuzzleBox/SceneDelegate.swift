//
//  SceneDelegate.swift
//  PuzzleBox
//
//  Created by Raline Maria da Silva on 06/05/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let navigationController = UINavigationController()
        let controller = ViewController()
        
        window.rootViewController = controller
        self.window = window
        window.makeKeyAndVisible()
    }

}

