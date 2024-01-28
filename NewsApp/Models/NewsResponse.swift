//
//  NewsResponse.swift
//  NewsApp
//
//  Created by Alexandr Rassokhin on 27.01.2024.
//

import Foundation

struct NewsResponse: Decodable {
    let id: String
    let description: String?
    let imageURL: String?
    let creators: [String]?
    let date: Date
    let sourceURL: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "article_id"
        case description = "description"
        case imageURL = "image_url"
        case creators = "creator"
        case date = "pubDate"
        case sourceURL = "link"
    }
}
