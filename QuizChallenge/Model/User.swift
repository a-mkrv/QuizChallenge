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

class User: Object, Mappable, Endpoint {
    
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var email = ""
    @objc dynamic var points = 0
    @objc dynamic var isDisableAD = false
    
    var statistics = Statistics()
    var session: Session?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id      <- map["id"]
        name    <- map["name"]
        email   <- map["email"]
        points  <- map["points"]
        isDisableAD <- map["is_disable_ad"]
        statistics  <- map["statistics"]
        session     <- map["session"]
    }
    
    static func url() -> String {
        return "https://quizbackend.com/user"
    }
}
