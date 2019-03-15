//
//  Opponent.swift
//  QuizChallenge
//
//  Created by A.Makarov on 15/03/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class Opponent: Object, Mappable, Endpoint {
    
    @objc dynamic var id = ""
    @objc dynamic var username = ""
    @objc dynamic var winsGame = 0
    @objc dynamic var lossesGame = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id          <- map["id"]
        username    <- map["username"]
        winsGame    <- map["wins_game"]
        lossesGame    <- map["losses_game"]
    }
    
    static func url() -> String {
        return "/searchOpponent"
    }
}
