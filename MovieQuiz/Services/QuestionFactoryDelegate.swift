//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Тихтей  Павел on 05.11.2022.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer() // сообщение об успешной загрузке
    func didFailToLoadData(with error: String)
}
