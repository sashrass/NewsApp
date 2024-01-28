//
//  AllNewsContentManager.swift
//  NewsApp
//
//  Created by Alexandr Rassokhin on 27.01.2024.
//

import Foundation

class AllNewsContentManager: ContentListContentManagerProtocol {
    
    var contentAddedHandler: ((ContentModel) -> Void)?
    var contentDeletedHandler: ((ContentModel) -> Void)?
    
    private var currentlyLoadingPageId: String?
    private var nextPageId: String?
    
    func fetchInitialContent(completion: @escaping (Result<[ContentModel], LoadContentError>) -> Void) {
        fetchContent(completion: completion)
    }
    
    func fetchMoreContent(completion: @escaping (Result<[ContentModel], LoadContentError>) -> Void) {
        guard currentlyLoadingPageId == nil else {
            completion(.failure(.alreadyLoading))
            return
        }
        
        currentlyLoadingPageId = nextPageId
        
        fetchContent(completion: completion)
    }
    
    private func fetchContent(completion: @escaping (Result<[ContentModel], LoadContentError>) -> Void) {
        let content = (0...10).map { _ in NewsResponse(id: UUID().uuidString,
                                                       description: randomString(length: (10...100).randomElement()!),
                                                       imageURL: "https://picsum.photos/\((10...300).randomElement()!)",
                                                       creators: [randomString(length: (10...20).randomElement()!)],
                                                       date: Date(),
                                                       sourceURL: "www.google.com") }
        let randomNumber = Double((1...3).randomElement()!)
        
        let models = mapNewsResponsesToContentModels(content)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + randomNumber) {
            completion(.success(models))
            
            self.nextPageId = UUID().uuidString
            self.currentlyLoadingPageId = nil
        }
    }
    
    private func mapNewsResponsesToContentModels(_ responses: [NewsResponse]) -> [ContentModel] {
        let models = responses.map { response in
            ContentModel(id: response.id,
                         description: response.description ?? "",
                         author: response.creators?.first ?? "",
                         imageURL: URL(string: response.imageURL ?? ""),
                         date: response.date,
                         sourceURL: URL(string: response.sourceURL ?? ""),
                         isFavorite: false)
        }
        
        return models
    }
}

private func randomString(length: Int) -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    return String((0..<length).map{ _ in letters.randomElement()! })
}
