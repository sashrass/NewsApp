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
    func navigateToContentDetails(with contentModel: ContentModel)
}

protocol ContentListViewModelProtocol {
    var contentConfigurations: [ContentCollectionCellConfiguration] { get }
    
    func setup()
    func fetchMoreContent()
    func didSelectContent(with index: Int)
}

protocol ContentListViewModelOutput: AnyObject {
    func contentDidChange()
}

protocol ContentListContentManagerProtocol {
    var contentAddedHandler: ((ContentModel) -> Void)? { get set }
    var contentDeletedHandler: ((ContentModel) -> Void)? { get set }
    
    func fetchInitialContent(completion: @escaping (Result<[ContentModel], LoadContentError>) -> Void)
    func fetchMoreContentIfNeeded(completion: @escaping (Result<[ContentModel], LoadContentError>) -> Void)
}
