//
//  Registration.swift
//  QuizChallenge
//
//  Created by Anton Makarov on 19/02/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class Registration: Object, Mappable, Endpoint {
    
    @objc dynamic var token = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        token   <- map["token"]
    }
    
    static func url() -> String {
        return "/users"
    }
}
