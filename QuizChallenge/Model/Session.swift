//
//  Session.swift
//  QuizChallenge
//
//  Created by Anton Makarov on 25/01/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class Session: Object, Mappable, Endpoint {
    
    @objc dynamic var id = ""
    @objc dynamic var user1ID = ""
    @objc dynamic var user2ID = ""
    @objc dynamic var startTime = ""
    @objc dynamic var finishTime = ""
    @objc dynamic var categoryQuestions = ""
    @objc dynamic var opponentName = ""
    @objc dynamic var opponentImageUrl = ""
    @objc dynamic var opponentScore = 0
    @objc dynamic var myScore = 0
    @objc dynamic var totalRounds = 0
    @objc dynamic var endRounds = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func mapping(map: Map) {
        id                  <- map["id"]
        user1ID             <- map["user1_id"]
        user2ID             <- map["user2_id"]
        startTime           <- map["started_at"]
        finishTime          <- map["finished_at"]
        categoryQuestions   <- map["category_questions"]
        opponentName        <- map["opponent_name"]
        opponentImageUrl    <- map["opponent_image_url"]
        opponentScore       <- map["opponent_score"]
        myScore             <- map["my_score"]
        totalRounds         <- map["total_rounds"]
        endRounds           <- map["end_rounds"]
    }
    
    static func url() -> String {
        return "/games"
    }
}
