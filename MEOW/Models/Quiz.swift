//
//  Quiz.swift
//  CatTastUIKit
//
//  Created by San Byn Nguyen on 18.05.2020.
//  Copyright © 2020 San Byn Nguyen. All rights reserved.
//

import UIKit

// MARK: - Quiz
struct Quiz: Codable, Identifiable {
    let id = UUID()
    var questions: [Question]
    
    var score: Int {
        return questions
            .map { $0.isAnsweredRight ? 1 : 0}
            .reduce(0, +)
    }
    
    var percentScore: Double {
        return Double(score) / Double(questions.count)
    }
}

// MARK: - Question
struct Question: Codable, Identifiable {
    let id = UUID()
    let question: String
    let image: String?
    let rightAnswer: String
    let otherOptions: [String]
    var selectedAnswer: String? = nil
    let catImage: CatImage
    
    var isAnswered: Bool {
        return selectedAnswer != nil
    }
    
    var isAnsweredRight: Bool {
        return selectedAnswer == rightAnswer
    }
    
    var shuffledAnswers: [String] {
        var allAnswers = otherOptions
        allAnswers.append(rightAnswer)
        return allAnswers.shuffled()
    }
}
