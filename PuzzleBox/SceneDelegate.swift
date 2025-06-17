//
//  SceneDelegate.swift
//  PuzzleBox
//
//  Created by Raline Maria da Silva on 06/05/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = scene as? UIWindowScene else { return }

        let navController = UINavigationController()
        let coordinator = AppCoordinator(navigationController: navController)
        self.coordinator = coordinator
        
        coordinator.start()
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = navController
        self.window = window
        window.makeKeyAndVisible()
    }

}

