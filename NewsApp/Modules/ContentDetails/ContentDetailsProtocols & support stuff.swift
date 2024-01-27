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
    
    func didSelectFavoriteButton()
}

protocol ContentDetailsViewModelOutput: AnyObject {
    func isFavoriteStatusDidChange()
}
