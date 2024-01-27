//
//  ContentDetailsAssembly.swift
//  NewsApp
//
//  Created by Alexandr Rassokhin on 27.01.2024.
//

import Foundation

class ContentDetailsAssembly {
    private init() { }
    
    static func build(contentModel: ContentModelProtocol) -> ContentDetailsViewController {
        let vc = ContentDetailsViewController()
        let vm = ContentDetailsViewModel(contentModel: contentModel)
        
        vm.output = vc
        vc.vm = vm
        
        return vc
    }
}
