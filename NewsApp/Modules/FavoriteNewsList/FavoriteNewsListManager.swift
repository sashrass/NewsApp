//
//  FavoriteNewsListManager.swift
//  NewsApp
//
//  Created by Alexandr Rassokhin on 28.01.2024.
//

import Foundation

class FavoriteNewsListManager: ContentListContentManagerProtocol {
    var contentAddedHandler: ((ContentModel) -> Void)?
    
    var contentDeletedHandler: ((ContentModel) -> Void)?
    
    private let storedContentManager = StoredContentManager()
    
    init() {
        setupHandlers()
    }
    
    func fetchInitialContent(completion: @escaping (Result<[ContentModel], LoadContentError>) -> Void) {
        let content = storedContentManager.contentList
        completion(.success(content))
    }
    
    func fetchMoreContent(completion: @escaping (Result<[ContentModel], LoadContentError>) -> Void) {
        completion(.failure(.noMoreContent))
    }
    
    private func setupHandlers() {
        storedContentManager.contentAddedHandler = { [weak self] content in
            self?.contentAddedHandler?(content)
        }
        
        storedContentManager.contentDeletedHandler = { [weak self] content in
            self?.contentDeletedHandler?(content)
        }
    }
}
