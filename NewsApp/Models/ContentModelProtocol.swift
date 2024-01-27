//
//  ContentModelProtocol.swift
//  NewsApp
//
//  Created by Alexandr Rassokhin on 27.01.2024.
//

import Foundation

protocol ContentModelProtocol {
    var contentId: String { get }
    var contentDescription: String { get }
    var contentAuthor: String { get }
    var contentImageURL: URL? { get }
    var contentDate: Date { get }
    var contentSourceLink: String { get }
}
