//
//  User.swift
//  QuizChallenge
//
//  Created by Anton Makarov on 24/01/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

protocol Endpoint {
    static func url() -> String
}

class User: Object, Mappable {
    
    @objc dynamic var id = ""
    @objc dynamic var username = ""
    @objc dynamic var email = ""
    @objc dynamic var realName = ""
    @objc dynamic var city = ""
    @objc dynamic var age = 0
    @objc dynamic var points = 0
    @objc dynamic var isDisableAD = false
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id          <- map["id"]
        username    <- map["username"]
        email       <- map["email"]
        realName    <- map["real_name"]
        city        <- map["city"]
        age         <- map["age"]
        points      <- map["game_points"]
        isDisableAD <- map["is_disable_ad"]
    }
}
