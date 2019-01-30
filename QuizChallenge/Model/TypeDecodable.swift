//
//  TypeDecodable.swift
//  QuizChallenge
//
//  Created by Anton Makarov on 30/01/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import Foundation

struct TypeDecodable: Codable {
    let typeQuestions: [TypeQuestion]
    
    enum CodingKeys: String, CodingKey {
        case typeQuestions = "type_questions"
    }
}

struct TypeQuestion: Codable {
    let name: String
    let types: [TypeElement]
}

struct TypeElement: Codable {
    let name, image: String
}


