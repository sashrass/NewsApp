//
//  ContentDetailsAssembly.swift
//  NewsApp
//
//  Created by Alexandr Rassokhin on 27.01.2024.
//

import Foundation

class ContentDetailsAssembly {
    private init() { }
    
    static func buildFromAllNewsList(contentModel: ContentModel) -> ContentDetailsViewController {
        let contentManager = AllNewsDetailsContentManager(contentResponseModel: contentModel)
        let vc = ContentDetailsViewController()
        let vm = ContentDetailsViewModel(contentId: contentModel.id,
                                         contentManager: contentManager)
        
        vm?.output = vc
        vc.vm = vm
        
        return vc
    }
    
    static func buildFromFavoriteNewsList(contentModel: ContentModel) -> ContentDetailsViewController {
        let contentManager = ContentDetailsContentManager(contentId: contentModel.id)
        let vc = ContentDetailsViewController()
        let vm = ContentDetailsViewModel(contentId: contentModel.id,
                                         contentManager: contentManager)
        
        vm?.output = vc
        vc.vm = vm
        
        return vc
    }
}
