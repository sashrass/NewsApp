//
//  ContentDetailsViewModel.swift
//  NewsApp
//
//  Created by Alexandr Rassokhin on 27.01.2024.
//

import Foundation

class ContentDetailsViewModel: ContentDetailsViewModelProtocol {
    
    var contentConfiguration: ContentDetailsViewConfiguration
    var isFavorite: Bool {
        didSet {
            output?.isFavoriteStatusDidChange()
        }
    }
    
    weak var output: ContentDetailsViewModelOutput?
    
    init(contentModel: ContentModelProtocol) {
        self.contentConfiguration = contentModel.contentConfiguration
        self.isFavorite = false
    }
    
    func didSelectFavoriteButton() {
        
    }
}

private extension ContentModelProtocol {
    var contentConfiguration: ContentDetailsViewConfiguration {
        ContentDetailsViewConfiguration(imageURL: self.contentImageURL,
                                        descriptionText: self.contentDescription,
                                        secondaryText: self.contentAuthor,
                                        thirdText: self.contentSourceLink)
    }
}
