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
    
    var curUser: User {
        if let user = RealmManager.shared.getObjectByID(Login.self, id: 0)?.user {
            return user
        }
        return User()
    }
    
    var userName: String {
        get { return UserDefaults.standard.userName ?? "Unknown" }
        set { UserDefaults.standard.userName = newValue }
    }
    
    var isLoggedIn: Bool {
        get { return UserDefaults.standard.isLoggedIn ?? false }
        set { UserDefaults.standard.isLoggedIn = newValue }
    }
    
    var userToken: String {
        get { return UserDefaults.standard.userToken ?? "" }
        set { UserDefaults.standard.userToken = newValue }
    }
    
    func logOut(complition: BoolClosure) {
        do {
            try RealmManager.shared.clearAllData()
            UserDefaults.standard.clearAllAppData()
            complition(true)
        } catch {
            Logger.error(msg: "Realm Storage Error. Unable to cleare data")
            complition(false)
        }
    }
}
