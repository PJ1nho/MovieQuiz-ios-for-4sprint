//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Тихтей  Павел on 10.11.2022.
//

import Foundation

struct GameRecord: Codable, Comparable {
    let correct: Int
    let total: Int
    let date: Date
    
    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
            return lhs.correct < rhs.correct
    }
}

