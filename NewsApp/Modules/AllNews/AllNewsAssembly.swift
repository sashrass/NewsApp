//
//  AllNewsAssembly.swift
//  NewsApp
//
//  Created by Alexandr Rassokhin on 27.01.2024.
//

import Foundation

final class AllNewsAssembly {
    private init() { }
    
    static func build() -> ContentListViewController {
        let vc = ContentListViewController()
        let vm = ContentListViewModel()
        let service = AllNewsService()
        let router = ContentListRouter()
        
        router.vc = vc
        vm.service = service
        vm.output = vc
        vm.router = router
        vc.vm = vm
        
        return vc
    }
}
