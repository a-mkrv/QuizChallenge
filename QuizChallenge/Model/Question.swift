//
//  Question.swift
//  QuizChallenge
//
//  Created by Anton Makarov on 21/01/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class Question: Object, Mappable, Endpoint {
    
    @objc dynamic var id = 0
    @objc dynamic var text = ""
    @objc dynamic var image = ""
    let answers = List<Answer>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id      <- map["id"]
        text    <- map["text"]
        image   <- map["image"]
        
        var answers: [Answer]?
        answers <- map["answers"]
        
        if let ansArray = answers {
            for answer in ansArray {
                self.answers.append(answer)
            }
        }
    }
    
    static func url() -> String {
        return "http://138.68.106.0:8080/question"
    }
}

class Answer: Object, Mappable {
    
    @objc dynamic var id = 0
    @objc dynamic var text = ""
    @objc dynamic var isCorrect = false
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id      <- map["id"]
        text    <- map["text"]
        isCorrect   <- map["is_correct"]
    }
}
