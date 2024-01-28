//
//  ContentListViewModel.swift
//  NewsApp
//
//  Created by Alexandr Rassokhin on 27.01.2024.
//

import Foundation

class ContentListViewModel: ContentListViewModelProtocol {
    
    var contentConfigurations: [ContentCollectionCellConfiguration] = [] {
        didSet {
            output?.contentDidChange()
        }
    }
    
    var router: ContentListRoutingLogic?
    weak var output: ContentListViewModelOutput?
    var contentManager: ContentListContentManagerProtocol?
    
    var contentModels: [ContentModel] = [] {
        didSet {
            contentConfigurations = contentModels.map { $0.contentCellConfiguration }
        }
    }
    
    func setup() {
        setupContentManager()
        
        contentManager?.fetchInitialContent(completion: { [weak self] result in
            DispatchQueue.main.async {
                self?.handleContentReceiving(result: result)
            }
        })
    }
    
    func fetchMoreContent() {
        contentManager?.fetchMoreContent { [weak self] result in
            DispatchQueue.main.async {
                self?.handleContentReceiving(result: result)
            }
        }
    }
    
    func didSelectContent(with index: Int) {
        let contentModel = contentModels[index]
        router?.navigateToContentDetails(with: contentModel)
    }
}

extension ContentListViewModel {
    
    private func setupContentManager() {
        contentManager?.contentAddedHandler = { [weak self] content in
            self?.handleContentAddition(content: content)
        }
        
        contentManager?.contentDeletedHandler = { [weak self] content in
            self?.handleContentRemoval(content: content)
        }
    }
    
    private func handleContentAddition(content: ContentModel) {
        contentModels.insert(content, at: 0)
    }
    
    private func handleContentRemoval(content: ContentModel) {
        contentModels.removeAll(where: { $0.id == content.id })
    }
    
    private func handleContentReceiving(result: Result<[ContentModel], LoadContentError>) {
        switch result {
        case .success(let content):
            contentModels.append(contentsOf: content)
        case .failure:
            break
        }
    }
    
}

private extension ContentModel {
    var contentCellConfiguration: ContentCollectionCellConfiguration {
        ContentCollectionCellConfiguration(id: self.id,
                                           title: self.description,
                                           secondText: self.date.formatted(),
                                           thirdText: self.author,
                                           imageURL: self.imageURL)
    }
}
