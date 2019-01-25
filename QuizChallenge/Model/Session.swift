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

class Session: Object, Mappable {
    
    @objc dynamic var id = 0
    @objc dynamic var quizType = ""
    @objc dynamic var opponentName = ""
    @objc dynamic var opponentImageUrl = ""
    @objc dynamic var opponentScore = 0
    @objc dynamic var myScore = 0
    @objc dynamic var totalRounds = 0
    @objc dynamic var endRounds = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        quizType <- map["quiz_type"]
        opponentName <- map["opponent_name"]
        opponentImageUrl <- map["opponent_image_url"]
        opponentScore <- map["opponent_score"]
        myScore <- map["my_score"]
        totalRounds <- map["total_rounds"]
        endRounds <- map["end_rounds"]
    }
}
