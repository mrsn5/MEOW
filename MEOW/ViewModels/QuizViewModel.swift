//
//  QuizViewModel.swift
//  MEOW
//
//  Created by San Byn Nguyen on 23.05.2020.
//  Copyright © 2020 San Byn Nguyen. All rights reserved.
//

import Foundation

class QuizViewModel {
    
    private let service = QuizService()
    private let startQuizHadler: ((Quiz) -> ())?
    private var answerSavedCompletions: [((Bool) -> ())] = []
    
    private(set) var quiz: Quiz?
    
    init(startQuizHadler: ((Quiz) -> ())? = nil) {
        self.startQuizHadler = startQuizHadler
    }
    
    
    func start() {
        service.generateQuiz { [weak self] res in
            if case .success(let quiz) = res {
                self?.quiz = quiz
                DispatchQueue.main.async {
                    self?.startQuizHadler?(quiz)
//                    self?.service.cancel()
                }
            }
        }
    }
    
    func seveAnswer(_ answer: String, for question: Question, completion: ((Bool) -> ())? = nil) {
        if let index = quiz?.questions.firstIndex(where: { question.id == $0.id }) {
            quiz?.questions[index].selectedAnswer = answer
            completion?(quiz?.questions[index].isAnsweredRight ?? false)
            
            for completion in answerSavedCompletions {
                completion(quiz?.questions[index].isAnsweredRight ?? false)
            }
        }
    }
    
    func subscribeAnswerWasSaved(completion: @escaping (Bool) -> ()) {
        answerSavedCompletions.append(completion)
    }
}
