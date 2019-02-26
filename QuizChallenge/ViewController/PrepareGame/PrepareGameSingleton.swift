//
//  PrepareGameSingleton.swift
//  QuizChallenge
//
//  Created by A.Makarov on 26/02/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import Foundation

class PrepareGameSingleton {
    
    static let shared = PrepareGameSingleton()
    
    var type: TypeGame? {
        didSet {
            typeQuestion = nil
            selectCategory = nil
            selectSubCategory = nil
            opponentName = nil
        }
    }
    
    var typeQuestion: QuizType?
    var selectCategory: String?
    var selectSubCategory: String?
    var opponentName: String?
    
}
