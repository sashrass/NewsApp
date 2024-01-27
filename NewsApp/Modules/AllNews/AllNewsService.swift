//
//  AllNewsService.swift
//  NewsApp
//
//  Created by Alexandr Rassokhin on 27.01.2024.
//

import Foundation

class AllNewsService: ContentListServiceProtocol {
    private var currentlyLoadingPageId: String?
    private var nextPageId: String?
    
    func fetchInitialContent(completion: @escaping (Result<[ContentModelProtocol], LoadContentError>) -> Void) {
        fetchContent(completion: completion)
    }
    
    func fetchMoreContent(completion: @escaping (Result<[ContentModelProtocol], LoadContentError>) -> Void) {
        guard currentlyLoadingPageId == nil else {
            completion(.failure(.alreadyLoading))
            return
        }
        
        currentlyLoadingPageId = nextPageId
        
        fetchContent(completion: completion)
    }
    
    private func fetchContent(completion: @escaping (Result<[ContentModelProtocol], LoadContentError>) -> Void) {
        let content = (0...10).map { _ in NewsResponse(id: UUID().uuidString,
                                                       description: randomString(length: (10...100).randomElement()!),
                                                       imageURL: "https://picsum.photos/200",
                                                       creators: [randomString(length: (10...20).randomElement()!)],
                                                       date: Date(),
                                                       sourceURL: "www.google.com") }
        let randomNumber = Double((1...3).randomElement()!)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + randomNumber) {
            completion(.success(content))
            
            self.nextPageId = UUID().uuidString
            self.currentlyLoadingPageId = nil
        }
    }
}

private func randomString(length: Int) -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    return String((0..<length).map{ _ in letters.randomElement()! })
}
