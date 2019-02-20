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
    
    @objc dynamic var id = 0
    @objc dynamic var token = ""
    @objc dynamic var user: User? = nil
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func mapping(map: Map) {
        token   <- map["token"]
        user    <- map["user"]
    }
    
    static func url() -> String {
        return "/users/login"
    }
}
