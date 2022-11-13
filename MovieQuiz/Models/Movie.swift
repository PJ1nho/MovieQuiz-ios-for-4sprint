//
//  MovieModel.swift
//  MovieQuiz
//
//  Created by Тихтей  Павел on 09.11.2022.
//

import Foundation

struct Movie: Codable {
    let id: String
    let rank: String
    let title: String
    let fullTitle: String
    let year: String
    let image: String
    let crew: String
    let imDbRating: String
    let imDbRatingCount: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        rank = try container.decode(String.self, forKey: .rank)
        title = try container.decode(String.self, forKey: .title)
        fullTitle = try container.decode(String.self, forKey: .fullTitle)
        year = try container.decode(String.self, forKey: .year)
        image = try container.decode(String.self, forKey: .image)
        crew = try container.decode(String.self, forKey: .crew)
        imDbRating = try container.decode(String.self, forKey: .imDbRating)
        imDbRatingCount = try container.decode(String.self, forKey: .imDbRatingCount)
    }
    
    enum CodingKeys: String, CodingKey {
        case id, rank, title, year, image, fullTitle, crew, imDbRating, imDbRatingCount
    }
}

