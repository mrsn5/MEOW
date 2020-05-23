//
//  QuizView.swift
//  CatTastUIKit
//
//  Created by San Byn Nguyen on 16.05.2020.
//  Copyright © 2020 San Byn Nguyen. All rights reserved.
//

import UIKit

class QuizView: UIViewController {
    
    @IBOutlet weak var cardsView: CardStackView!
    @IBOutlet weak var numberOfQuestionLabel: UILabel!
    @IBOutlet weak var progressBar: ProgressBar!
    @IBOutlet weak var nextButton: RoundedButton!
    var activityView = UIActivityIndicatorView(style: .large)
    
    private var viewModel: QuizViewModel!
    
//    init(viewModel: QuizViewModel) {
//        super.init(nibName: String(describing: Self.self), bundle: nil)
//        self.viewModel = viewModel
//    }
//    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        start()
    }
    
    func start() {
        startActivityIndicatory()
        viewModel = QuizViewModel(
            startQuizHadler: { quiz in
                self.cardsView.reloadData()
                self.setQuestion(number: 1, from: quiz.questions.count)
                self.stopActivityIndicatory()
        })
        viewModel.subscribeAnswerWasSaved { [weak self] result in
            self?.nextButton.isHidden = false
        }
        viewModel.start()
        cardsView.delegate = self
    }
    
    func setQuestion(number: Int, from: Int) {
        numberOfQuestionLabel.text = "Question \(number)/\(from)"
        progressBar.setProgress( Float(number) / Float(from), animated: true)
        
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        nextButton.isHidden = true
        cardsView.nextCard()
    }
    
    @IBAction func crossTapped(_ sender: Any) {
        QuizCoordinator.shared.showMenu()
    }
    
    func startActivityIndicatory() {
        activityView.isHidden = false
        activityView.center = self.view.center
        self.view.addSubview(activityView)
        activityView.startAnimating()
    }
    
    func stopActivityIndicatory() {
        activityView.stopAnimating()
        activityView.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        activityView.center = self.view.center
    }
}


extension QuizView: CardStackDelegate {
    
    func numberOfItems() -> Int {
        return  viewModel.quiz?.questions.count ?? 0
    }
    
    func cardStack(viewForItem at: Int) -> CardContent {
        let view = QuestionView.instantiate()
        if let question = viewModel.quiz?.questions[at] {
            view.configure(question: question, viewModel: viewModel)
        }
        return view
    }
    
    func swipeWillStart() {
        self.nextButton.isHidden = true
    }
    
    func cardStack(swipeDidEndHandler at: Int) {
        nextButton.isHidden = true
        
        if at + 1 == numberOfItems() {
            QuizCoordinator.shared.showResults(viewModel: viewModel)
        } else {
            self.setQuestion(number: at + 2, from: numberOfItems())
        }
    }
}
