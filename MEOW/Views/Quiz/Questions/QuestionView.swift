//
//  QuestionView.swift
//  CatTastUIKit
//
//  Created by San Byn Nguyen on 19.05.2020.
//  Copyright © 2020 San Byn Nguyen. All rights reserved.
//

import UIKit

class CardContent: UIView {
    func activate() { fatalError("abstract") }
}

class QuestionView: CardContent {
    
    private let imageViewModel = ImageViewModel<ImageRAMCache>(service: UIImageService(cache: ImageRAMCache.shared, policy: .loadCacheElseLoad))
    private var viewModel: QuizViewModel!
    private(set) var question: Question!
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    var buttons: [UIButton] = []
    var answered = false
    
    override func awakeFromNib() {
        buttons = [button1, button2, button3, button4]
        for b in buttons {
            b.titleLabel?.numberOfLines = 0
            b.titleLabel?.lineBreakMode = .byWordWrapping
            b.titleLabel?.textAlignment = .center
        }
        disable()
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        guard let button = sender as? UIButton else { return }
        guard let answer = button.titleLabel?.text else { return }
        guard !answered else { return }
        answered = true
        viewModel.seveAnswer(answer, for: question) { [weak self] result in
            guard let self = self else { return }
            button.backgroundColor = result ? UIColor(named: "primary") : .darkGray
            button.setTitleColor(UIColor(named: "light shadow"), for: .normal)
            
            for b in self.buttons {
                guard let title = b.titleLabel?.text else { continue }
                if title == self.question.rightAnswer {
                    b.backgroundColor = UIColor(named: "primary")
                    b.setTitleColor(UIColor(named: "light shadow"), for: .normal)
                }
                
            }
        }
        disable()
    }
    
    func configure(question: Question, viewModel: QuizViewModel) {
        self.viewModel = viewModel
        self.question = question
        
        for data in zip(buttons, question.shuffledAnswers) {
            data.0.setTitle(data.1, for: .normal)
        }
        questionLabel.text = question.question
        if let image = question.image {
            imageView.image = UIImage.makeImage(from: UIColor(named: "light shadow")!)
            
            imageViewModel.load(string: image) { [weak self] image in
                guard let image = image else { return }
                guard let size = self?.imageView.frame.size else { return }
                DispatchQueue.global(qos: .userInteractive).async {
                    let resized = image.resizeFillImage(for: size)
                    DispatchQueue.main.async {
                        self?.imageView.image = resized
                    }
                }
                
            }
        }
    }
    
    override func activate() {
        for b in buttons {
            b.isEnabled = true
        }
    }
    
    func disable() {
        for b in buttons {
            b.isEnabled = false
        }
    }
    
    deinit {
        if let image = question.image {
            imageViewModel.cancel(string: image)
        }
    }
}
