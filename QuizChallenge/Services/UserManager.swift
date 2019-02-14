//
//  UserManager.swift
//  QuizChallenge
//
//  Created by Anton Makarov on 12/02/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import Foundation

class UserManager {
   
    static let shared = UserManager()
    
    var isLoggedIn: Bool {
        get { return UserDefaults.standard.isLoggedIn ?? false }
        set { UserDefaults.standard.isLoggedIn = newValue }
    }
    
    func logOut() {
        try! RealmManager.shared.clearAllData()
        UserDefaults.standard.clearAllAppData()
    }
}
