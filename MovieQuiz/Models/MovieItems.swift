//
//  ActorModel.swift
//  MovieQuiz
//
//  Created by Тихтей  Павел on 09.11.2022.
//

import Foundation

struct MovieItems: Codable {
    let items: [Movie]
    let errorMessage: String
}
