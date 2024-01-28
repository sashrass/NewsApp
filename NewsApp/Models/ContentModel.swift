//
//  ContentModel.swift
//  NewsApp
//
//  Created by Alexandr Rassokhin on 28.01.2024.
//

import Foundation
import CoreData

struct ContentModel {
    var id: String
    var description: String
    var author: String
    var imageURL: URL?
    var date: Date?
    var sourceURL: URL?
    var isFavorite: Bool
}
