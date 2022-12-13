import UIKit

final class MovieQuizViewController: UIViewController, AlertDelegate, MovieQuizViewControllerProtocol {
    
    // MARK: - Variables
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    private var presenter: MovieQuizPresenter!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MovieQuizPresenter(viewController: self)
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        showLoadingIndicator()
        presenter.alertPresenter = AlertPresenter(delegate: self)
    }
    
    // MARK: - AlertDelegate
    func show(alert: UIAlertController) {
        present(alert, animated: true, completion: nil)
    }
    // MARK: - Functions
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        
    }
    
    func hideBorder(){
        imageView.layer.borderWidth = 0
    }
    
    func drawBorder(color: UIColor) {
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = color.cgColor
    }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func showNetworkError(message: String) {
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") {
        }
        presenter.alertPresenter?.configure(model: model)
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        presenter.didReceiveNextQuestion(question: question)
    }
    
    func hideActivityIndicator() {
        activityIndicator.isHidden = true 
    }
}
