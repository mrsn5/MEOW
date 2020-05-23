//
//  QuizResultsView.swift
//  CatTastUIKit
//
//  Created by San Byn Nguyen on 21.05.2020.
//  Copyright © 2020 San Byn Nguyen. All rights reserved.
//

import UIKit

class QuizResultsView: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scoreLable: UILabel!
    @IBOutlet weak var row1: UIView!
    @IBOutlet weak var row2: UIView!
    
    private var viewModel: QuizViewModel!
    
    init(viewModel: QuizViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: Self.self), bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = viewModel.quiz?.percentScore ?? 0.0 >= 0.6 ? "Congratulations!" : "Oops"
        scoreLable.text = "\(viewModel.quiz?.score ?? 0)/\(viewModel.quiz?.questions.count ?? 0)"
        setupSeenBreeds()
    }
    
    func setupSeenBreeds() {
        let breeds = viewModel.quiz?.questions.compactMap { $0.catImage.breeds?[0] }
        let seenKittens = HorizontalBreedList.instantiate()
        seenKittens.title.text = "Kittens shown"
        seenKittens.dataSource = breeds ?? []
        row1.addSubview(seenKittens)
        seenKittens.translatesAutoresizingMaskIntoConstraints = true
        seenKittens.frame = CGRect(x: 0, y: 0, width: row1.frame.width, height: row1.frame.height)
    }

    @IBAction func playAgainTapped(_ sender: Any) {
        QuizCoordinator.shared.startQuiz()
    }
    
    @IBAction func closeTapped(_ sender: Any) {
        QuizCoordinator.shared.showMenu()
    }
}
