//
//  AllNewsDetailsContentManager.swift
//  NewsApp
//
//  Created by Alexandr Rassokhin on 28.01.2024.
//

import Foundation

class AllNewsDetailsContentManager: ContentDetailsContentManager {
    var contentResponseModel: ContentModel
    
    init(contentResponseModel: ContentModel) {
        self.contentResponseModel = contentResponseModel
        super.init(contentId: contentResponseModel.id)
    }
    
    override func fetchContent(by id: String) -> ContentModel? {
        if let model = storedContentManager.fetchContent(by: id) {
            return model
        } else {
            return contentResponseModel
        }
    }
}
