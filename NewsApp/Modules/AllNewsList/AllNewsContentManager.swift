//
//  AllNewsContentManager.swift
//  NewsApp
//
//  Created by Alexandr Rassokhin on 27.01.2024.
//

import Foundation

class AllNewsContentManager: ContentListContentManagerProtocol {
    
    private var token: String {
        Bundle.main.object(forInfoDictionaryKey: "NewsData_APIKey") as! String
    }
    
    private var baseURLComponents: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "newsdata.io"
        components.path = "/api/1/news"
        components.queryItems = [
            URLQueryItem(name: "apikey", value: token)
        ]
        return components
    }
    
    var contentAddedHandler: ((ContentModel) -> Void)?
    var contentDeletedHandler: ((ContentModel) -> Void)?
    
    private var currentlyLoadingPageId: String?
    private var nextPageId: String?
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter
    }()
    
    func fetchInitialContent(completion: @escaping (Result<[ContentModel], LoadContentError>) -> Void) {
        let url = getBaseURL()
        fetchContent(for: url, completion: completion)
    }
    
    func fetchMoreContentIfNeeded(completion: @escaping (Result<[ContentModel], LoadContentError>) -> Void) {
        guard currentlyLoadingPageId == nil else {
            completion(.failure(.alreadyLoading))
            return
        }
        
        guard let nextPageId else {
            completion(.failure(.noMoreContent))
            return
        }
        
        currentlyLoadingPageId = nextPageId
        let url = getURLForNextPage(nextPageId: nextPageId)
        
        fetchContent(for: url, completion: completion)
    }
    
    private func fetchContent(for url: URL, completion: @escaping (Result<[ContentModel], LoadContentError>) -> Void) {
//        #if DEBUG
//        fetchContentDebug(for: url, completion: completion)
//        #else
        // test with enabled VPN for loading images
        fetchContentRelease(for: url, completion: completion)
//        #endif
    }
    
    private func fetchContentRelease(for url: URL, completion: @escaping (Result<[ContentModel], LoadContentError>) -> Void) {
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard error == nil, let data else {
                completion(.failure(.loadingFailed))
                return
            }
            
            let newsInfoResponse = try? JSONDecoder().decode(NewsInfoResponse.self, from: data)
            
            guard let newsInfoResponse,
                  let models = self?.mapNewsResponsesToContentModels(newsInfoResponse.results) else {
                completion(.failure(.loadingFailed))
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(models))
                
                self?.nextPageId = newsInfoResponse.nextPage
                self?.currentlyLoadingPageId = nil
            }
            
        }.resume()
    }
    
        private func fetchContentDebug(for url: URL, completion: @escaping (Result<[ContentModel], LoadContentError>) -> Void) {
            let content = (0...10).map { _ in NewsResponse(id: UUID().uuidString,
                                                           description: randomString(length: (10...100).randomElement()!),
                                                           imageURL: "https://picsum.photos/\((10...300).randomElement()!)",
                                                           creators: [randomString(length: (10...20).randomElement()!)],
                                                           date: "2024-01-01 00:00:00",
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
        let models = responses.compactMap { response -> ContentModel? in
            return ContentModel(id: response.id,
                                description: response.description ?? "",
                                author: response.creators?.first ?? "",
                                imageURL: URL(string: response.imageURL ?? ""),
                                date: dateFormatter.date(from: response.date),
                                sourceURL: URL(string: response.sourceURL ?? ""),
                                isFavorite: false)
        }
        
        return models
    }
    
    private func getBaseURL() -> URL {
        baseURLComponents.url!
    }
    
    private func getURLForNextPage(nextPageId: String) -> URL {
        var baseComponents = baseURLComponents
        baseComponents.queryItems?.append(URLQueryItem(name: "page", value: nextPageId))
        return baseComponents.url!
    }
}

private func randomString(length: Int) -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    return String((0..<length).map{ _ in letters.randomElement()! })
}
