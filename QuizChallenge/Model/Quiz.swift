//
//  Quiz.swift
//  QuizChallenge
//
//  Created by Anton Makarov on 21/01/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import Foundation

enum  QuizType {
    case TrueOrFalse
    case GuessImage
    case TextQuiz
}

class Quiz: NSObject {
    let quizType: QuizType
    let timeForQuestion: Int
    let countQuestions: Int
    let isMultipleChoice: Bool
    
    init(qType: QuizType, time: Int, qCount: Int, isMultiple: Bool) {
        self.quizType = qType
        self.timeForQuestion = time
        self.countQuestions = qCount
        self.isMultipleChoice = isMultiple
    }
}
