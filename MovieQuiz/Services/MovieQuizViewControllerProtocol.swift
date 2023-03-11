//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Тихтей  Павел on 13.12.2022.
//
import UIKit

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func showLoadingIndicator()
    func hideActivityIndicator()
    func showNetworkError(message: String)
    func hideBorder()
    func drawBorder(color: UIColor)
}
