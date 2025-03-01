//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Тихтей  Павел on 10.11.2022.
//

import Foundation

protocol StatisticService {
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
    func store(correct count: Int, total amount: Int)
}

final class StatisticServiceImplementation: StatisticService {
    
    private let userDefaults = UserDefaults.standard
    
    var totalAccuracy: Double {
        get {
            return userDefaults.double(forKey: Keys.totalAccuracy.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.totalAccuracy.rawValue)
        }
    }
    
    var gamesCount: Int {
        get {
            return userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }
            return record
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        gamesCount += 1
        let currentAccuracy = Double(count) / Double(amount)
        var rangeOfAccuracy = userDefaults.array(forKey: Keys.rangeOfAccuracy.rawValue) as? [Double] ?? []
        var totalPrevAccuracy = 0.0
        
        for i in rangeOfAccuracy {
            totalPrevAccuracy += i
        }
        
        totalAccuracy = (totalPrevAccuracy + currentAccuracy) / Double(gamesCount)
        rangeOfAccuracy.append(currentAccuracy)
        userDefaults.set(rangeOfAccuracy, forKey: Keys.rangeOfAccuracy.rawValue)
        let currentGame = GameRecord(correct: count, total: amount, date: Date())
        if bestGame < currentGame {
            bestGame = currentGame
        }
    }
    
    private enum Keys: String {
        case correct, totalAccuracy, bestGame, gamesCount, rangeOfAccuracy
    }
}
