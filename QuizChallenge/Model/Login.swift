//
//  Login.swift
//  QuizChallenge
//
//  Created by Anton Makarov on 19/02/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class Login: Object, Mappable, Endpoint {
    
    @objc dynamic var token = 0
    var user: User?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        token   <- map["token"]
        user    <- map["user"]
    }
    
    static func url() -> String {
        return "/users/login"
    }
}
