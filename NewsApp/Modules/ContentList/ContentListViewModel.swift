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
    var service: ContentListServiceProtocol?
    
    var contentModels: [ContentModelProtocol] = [] {
        didSet {
            contentConfigurations = contentModels.map { $0.contentCellConfiguration }
        }
    }
    
    func setupContent() {
        service?.fetchInitialContent(completion: { [weak self] result in
            DispatchQueue.main.async {
                self?.handleContentReceiving(result: result)
            }
        })
    }
    
    func fetchMoreContent() {
        service?.fetchMoreContent { [weak self] result in
            DispatchQueue.main.async {
                self?.handleContentReceiving(result: result)
            }
        }
    }
    
    func didSelectContent(with index: Int) {
        let model = contentModels[index]
        router?.navigateToContentDetails(model: model)
    }
}

extension ContentListViewModel {
    private func handleContentReceiving(result: Result<[ContentModelProtocol], LoadContentError>) {
        switch result {
        case .success(let content):
            contentModels.append(contentsOf: content)
        case .failure:
            break
        }
    }
}

private extension ContentModelProtocol {
    var contentCellConfiguration: ContentCollectionCellConfiguration {
        ContentCollectionCellConfiguration(id: self.contentId,
                                           title: self.contentDescription,
                                           secondText: self.contentDescription,
                                           thirdText: self.contentAuthor,
                                           imageURL: self.contentImageURL)
    }
}
