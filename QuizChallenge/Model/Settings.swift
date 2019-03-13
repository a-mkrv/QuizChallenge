//
//  Settings.swift
//  QuizChallenge
//
//  Created by Anton Makarov on 30/01/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import Foundation
import RealmSwift

class SettingsModel: Object {
    @objc dynamic var id = 1
    @objc dynamic var notifications = true
    @objc dynamic var saveQuestions = true
    @objc dynamic var backgroundSound = true
    @objc dynamic var buyPremiumEnabled = true
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

