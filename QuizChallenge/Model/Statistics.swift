//
//  Statistics.swift
//  QuizChallenge
//
//  Created by Anton Makarov on 25/01/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class Statistics: Object, Mappable, Endpoint {
    
    @objc dynamic var totalGame = 0
    @objc dynamic var countLoss = 0
    @objc dynamic var countWins = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        totalGame   <- map["total_game"]
        countLoss   <- map["count_loss"]
        countWins   <- map["count_wins"]
    }
    
    static func url() -> String {
        return "https://quizbackend.com/statisctics"
    }
}

class TestModel: Object, Mappable, Endpoint {
    
    @objc dynamic var userId = 0
    @objc dynamic var id = 0
    @objc dynamic var title = ""
    @objc dynamic var completed = false
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func mapping(map: Map) {
        userId      <- map["userId"]
        id          <- map["id"]
        title       <- map["title"]
        completed   <- map["completed"]
    }
    
    static func url() -> String {
        return "https://jsonplaceholder.typicode.com/todos/1"
    }
    
}
