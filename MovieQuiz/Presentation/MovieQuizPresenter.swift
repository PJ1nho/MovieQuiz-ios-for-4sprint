//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Тихтей  Павел on 12.12.2022.
//

import UIKit

final class MovieQuizPresenter {
    private let questionsAmount = 10
    private var currentQuestionIndex = 0
    weak var viewController: MovieQuizViewController?
    private var currentQuestion: QuizQuestion?
    private var correctAnswers = 0
    private var questionFactory: QuestionFactoryProtocol?
    var alertPresenter: AlertPresenter?
    private var statisticService: StatisticService?
    
    init(viewController: MovieQuizViewController) {
        self.viewController = viewController
        self.questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        self.questionFactory?.loadData()
        self.statisticService = StatisticServiceImplementation()
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func yesButtonClicked() {
        showAnswerResult(isCorrect: true)
    }
    
    func noButtonClicked() {
        showAnswerResult(isCorrect: false)
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    func showNextQuestionOrResults() {
        viewController?.hideBorder()
        if self.isLastQuestion() {
            statisticService?.store(correct: correctAnswers, total: self.questionsAmount)
            let gamesCount = statisticService?.gamesCount ?? 0
            let bestGameCorrect = statisticService?.bestGame.correct ?? 0
            let bestGameTotal = statisticService?.bestGame.total ?? 0
            let bestGameDate = statisticService?.bestGame.date.dateTimeString ?? ""
            let totalAccuracy = statisticService?.totalAccuracy ?? 0
            let text = """
            Ваш результат \(correctAnswers) из 10
            Количество сыгранных квизов: \(gamesCount)
            Рекорд: \(bestGameCorrect) / \(bestGameTotal) (\(bestGameDate))
            Cредняя точность: \(String(format: "%.2f", totalAccuracy * 100))%
            """
            let alertModel = AlertModel(title: "Этот раунд окончен", message: text, buttonText: "Сыграть еще раз") { [weak self] in
                guard let self = self else { return }
                self.restartGame()
            }
            alertPresenter?.configure(model: alertModel)
            correctAnswers = 0
        } else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
    func didAnswer(isCorrectAnswer: Bool) {
        if (isCorrectAnswer) {
            correctAnswers += 1
        }
    }
    
    func requestNextQuestion() {
        questionFactory?.requestNextQuestion()
    }
    
    func showAnswerResult(isCorrect: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        if currentQuestion.correctAnswer == isCorrect {
            viewController?.drawBorder(color: .ypGreen)
            didAnswer(isCorrectAnswer: true)
        } else {
            viewController?.drawBorder(color: .ypRed)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
        }
    }
}

extension MovieQuizPresenter: QuestionFactoryDelegate {
    
    func didLoadDataFromServer() {
        viewController?.hideActivityIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        viewController?.showNetworkError(message: error.localizedDescription)
    }
}
