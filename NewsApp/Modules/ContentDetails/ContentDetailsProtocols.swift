//
//  ContentDetailsProtocols & support stuff.swift
//  NewsApp
//
//  Created by Alexandr Rassokhin on 27.01.2024.
//

import Foundation

protocol ContentDetailsViewModelProtocol {
    var contentConfiguration: ContentDetailsViewConfiguration { get }
    var isFavorite: Bool { get }
    
    func setup()
    func didSelectFavoriteButton()
}

protocol ContentDetailsViewModelOutput: AnyObject {
    func isFavoriteStatusDidChange()
}

protocol ContentDetailsContentManagerProtocol {
    var contentDidUpdateHandler: ((ContentModel) -> Void)? { get set }
    
    func fetchContent(by id: String) -> ContentModel?
    func updateContent(_ content: ContentModel)
}
