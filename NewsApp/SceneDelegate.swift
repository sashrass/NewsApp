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
        
        let tabBarVC = getTabBarVC()
        
        self.window?.rootViewController = tabBarVC
        self.window?.makeKeyAndVisible()
    }
    
    private func getTabBarVC() -> UITabBarController {
        let allNewsViewsVC = ContentListAssembly.buildAllNewsList()
        let favoriteNewsVC = ContentListAssembly.buildFavoriteNewsList()
        
        let allNewsNavigationController = UINavigationController(rootViewController: allNewsViewsVC)
        let favoriteNewsNavigationController = UINavigationController(rootViewController: favoriteNewsVC)
        
        allNewsNavigationController.tabBarItem = UITabBarItem(title: "All news",
                                                              image: UIImage(systemName: "newspaper"),
                                                              selectedImage: UIImage(systemName: "newspaper.fill"))
        
        favoriteNewsNavigationController.tabBarItem = UITabBarItem(title: "Favorite news",
                                                              image: UIImage(systemName: "star"),
                                                              selectedImage: UIImage(systemName: "star.fill"))
        
        let tabBarVC = UITabBarController()
        tabBarVC.viewControllers = [allNewsNavigationController, favoriteNewsNavigationController]
        
        return tabBarVC
    }

}

