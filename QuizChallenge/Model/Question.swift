//
//  Question.swift
//  QuizChallenge
//
//  Created by Anton Makarov on 21/01/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import Foundation

enum QuestCategory {
    case All
    case Animal
    case Sport
    case Education
    case Technology
    case Mainstream
    case Celebrities
    case History
    case Food
    case WorldAround
}

class Question: NSObject {
    let question: String
    let answers: [String]
    var correctAnswer: String
    let category: QuestCategory!
    var isCorrect: Bool = false
    let imageUrl: String?

    init(question: String, answers: [String], correct: String, category: QuestCategory, imgUrl: String? = nil) {
        self.question = question
        self.answers = answers
        self.correctAnswer = correct
        self.category = category
        self.imageUrl = imgUrl
    }
}
