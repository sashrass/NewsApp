//
//  SceneDelegate.swift
//  NewsApp
//
//  Created by Alexandr Rassokhin on 27.01.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let window = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: window)
        
        let navigationController = UINavigationController()
        navigationController.navigationBar.prefersLargeTitles = true
        
        let allNewsVC = AllNewsAssembly.build()
        navigationController.viewControllers = [allNewsVC]
        
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
    }

}

