import UIKit

final class MovieQuizViewController: UIViewController, AlertDelegate {
    
    // MARK: - Variables
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    private var correctAnswers: Int = 0
    private var presenter = MovieQuizPresenter()
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenter?
    private var statisticService: StatisticService?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        showLoadingIndicator()
        alertPresenter = AlertPresenter(delegate: self)
        statisticService = StatisticServiceImplementation()
    }
    
    // MARK: - AlertDelegate
    func show(alert: UIAlertController) {
        present(alert, animated: true, completion: nil)
    }
    // MARK: - Functions
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        showAnswerResult(isCorrect: false)
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        showAnswerResult(isCorrect: true)
    }
    
    private func show(quiz step: QuizStepViewModel) {
        // здесь мы заполняем нашу картинку, текст и счётчик данными
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        if currentQuestion.correctAnswer == isCorrect {
            // показать зеленую рамку
            drawBorder(color: .ypGreen)
            correctAnswers += 1
        } else {
            // показать красную рамку
            drawBorder(color: .ypRed)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        hideBorder()
        if presenter.isLastQuestion() { // - 1 потому что индекс начинается с 0, а длинна массива — с 1
            statisticService?.store(correct: correctAnswers, total: presenter.questionsAmount)
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
                self.presenter.resetQuestionIndex()
                self.questionFactory?.requestNextQuestion()
            }
            alertPresenter?.configure(model: alertModel)
            correctAnswers = 0
        } else {
            presenter.switchToNextQuestion() // увеличиваем индекс текущего урока на 1; таким образом мы сможем получить следующий урок
            questionFactory?.requestNextQuestion()
        }
    }
    private func hideBorder(){
        imageView.layer.borderWidth = 0
    }
    
    private func drawBorder(color: UIColor) {
        imageView.layer.borderWidth = 8 // толщина рамки
        imageView.layer.borderColor = color.cgColor // делаем рамку белой
    }
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func showNetworkError(message: String) {
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") {
        }
        alertPresenter?.configure(model: model)
    }
}

// MARK: - QuestionFactoryDelegate

extension MovieQuizViewController: QuestionFactoryDelegate {
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = presenter.convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true // скрываем индикатор загрузки
        questionFactory?.requestNextQuestion()
    }

    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
}
