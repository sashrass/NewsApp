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
    private var contentManager: ContentDetailsContentManagerProtocol
    
    private var contentModel: ContentModel
    
    init?(contentId: String, contentManager: ContentDetailsContentManagerProtocol) {
        guard let contentModel = contentManager.fetchContent(by: contentId) else { return nil }
        
        self.contentManager = contentManager
        self.contentModel = contentModel
        self.contentConfiguration = contentModel.contentConfiguration
        self.isFavorite = contentModel.isFavorite
    }
    
    func setup() {
        setupContentManager()
    }
    
    func didSelectFavoriteButton() {
        var model = contentModel
        model.isFavorite.toggle()
        
        contentManager.updateContent(model)
    }
    
    private func setupContentManager() {
        contentManager.contentDidUpdateHandler = { [weak self] content in
            self?.contentModel = content
            self?.isFavorite = content.isFavorite
        }
    }
}

private extension ContentModel {
    var contentConfiguration: ContentDetailsViewConfiguration {
        ContentDetailsViewConfiguration(imageURL: self.imageURL,
                                        descriptionText: self.description,
                                        secondaryText: "Author: \(self.author)",
                                        thirdText: "Link: \(self.sourceURL?.absoluteString ?? "")")
    }
}
