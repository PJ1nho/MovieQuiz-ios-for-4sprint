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
}

