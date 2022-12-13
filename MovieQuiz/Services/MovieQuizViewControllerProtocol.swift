//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Тихтей  Павел on 13.12.2022.
//

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func showLoadingIndicator()
    func hideActivityIndicator()
    func showNetworkError(message: String)
}
