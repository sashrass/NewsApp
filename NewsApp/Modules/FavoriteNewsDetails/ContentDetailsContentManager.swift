//
//  ContentDetailsContentManager.swift
//  NewsApp
//
//  Created by Alexandr Rassokhin on 28.01.2024.
//

import Foundation

class ContentDetailsContentManager: ContentDetailsContentManagerProtocol {
    var contentDidUpdateHandler: ((ContentModel) -> Void)?
    
    let storedContentManager = StoredContentManager()
    
    private let contentId: String
    
    init(contentId: String) {
        self.contentId = contentId
        setupHandlers()
    }
    
    func fetchContent(by id: String) -> ContentModel? {
        storedContentManager.fetchContent(by: id)
    }
    
    func updateContent(_ content: ContentModel) {
        if content.isFavorite {
            storedContentManager.addContent(content)
        } else {
            storedContentManager.deleteContent(content)
        }
    }
    
    private func setupHandlers() {
        storedContentManager.contentAddedHandler = { [weak self] content in
            guard content.id == self?.contentId else { return }
            self?.contentDidUpdateHandler?(content)
        }
        
        storedContentManager.contentDeletedHandler = { [weak self] content in
            guard content.id == self?.contentId else { return }
            self?.contentDidUpdateHandler?(content)
        }
    }
}
