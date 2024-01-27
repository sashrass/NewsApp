//
//  ContentListProtocols.swift
//  NewsApp
//
//  Created by Alexandr Rassokhin on 27.01.2024.
//

import Foundation

enum LoadContentError: Error {
    case alreadyLoading
    case noMoreContent
    case loadingFailed
}

protocol ContentListRoutingLogic {
    func navigateToContentDetails(model: ContentModelProtocol)
}

protocol ContentListViewModelProtocol {
    var contentConfigurations: [ContentCollectionCellConfiguration] { get }
    
    func setupContent()
    func fetchMoreContent()
    func didSelectContent(with index: Int)
}

protocol ContentListViewModelOutput: AnyObject {
    func contentDidChange()
}

protocol ContentListServiceProtocol {
    func fetchInitialContent(completion: @escaping (Result<[ContentModelProtocol], LoadContentError>) -> Void)
    func fetchMoreContent(completion: @escaping (Result<[ContentModelProtocol], LoadContentError>) -> Void)
}
