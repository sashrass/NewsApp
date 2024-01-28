//
//  ContentListAssembly.swift
//  NewsApp
//
//  Created by Alexandr Rassokhin on 27.01.2024.
//

import Foundation

final class ContentListAssembly {
    private init() { }
    
    static func buildAllNewsList() -> ContentListViewController {
        let vc = ContentListViewController()
        let vm = ContentListViewModel()
        let manager = AllNewsContentManager()
        let router = AllNewsListRouter()
        
        router.vc = vc
        vm.contentManager = manager
        vm.output = vc
        vm.router = router
        vc.vm = vm
        
        vc.title = "All news"
        
        return vc
    }
    
    static func buildFavoriteNewsList() -> ContentListViewController {
        let vc = ContentListViewController()
        let vm = ContentListViewModel()
        let manager = FavoriteNewsListManager()
        let router = FavoriteNewsListRouter()
        
        router.vc = vc
        vm.contentManager = manager
        vm.output = vc
        vm.router = router
        vc.vm = vm
        
        vc.title = "Favorite news"
        
        return vc
    }
}
