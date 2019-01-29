//
//  UserDefaults+Extension.swift
//  QuizChallenge
//
//  Created by Anton Makarov on 27/01/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import Foundation

fileprivate let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String

extension UserDefaults {
    
    private enum UserDefaultsKeys: String {
        case isLoggedIn
        case userToken
        case userLogin
        case userRating
    }
    
    private func createKey(_ key: String) -> String {
        return (appName ?? "QuizChallenge") + "-" + key
    }
    
    //FIXME: Refactoring in separate one object (UserManager)
    var isLoggedIn: Bool? {
        set {
            set(newValue, forKey: createKey(UserDefaultsKeys.isLoggedIn.rawValue))
            synchronize()
        }
        get { return bool(forKey: createKey(UserDefaultsKeys.isLoggedIn.rawValue)) }
    }
    
    var userToken: String? {
        set {
            set(newValue, forKey: createKey(UserDefaultsKeys.userToken.rawValue))
            synchronize()
        }
        get { return string(forKey: createKey(UserDefaultsKeys.userToken.rawValue)) }
    }
    
    var userLogin: String? {
        set {
            set(newValue, forKey: createKey(UserDefaultsKeys.userLogin.rawValue))
            synchronize()
        }
        get { return string(forKey: createKey(UserDefaultsKeys.userLogin.rawValue)) }
    }
    
    var userRating: Int? {
        set {
            set(newValue, forKey: createKey(UserDefaultsKeys.userRating.rawValue))
            synchronize()
        }
        get { return integer(forKey: createKey(UserDefaultsKeys.userRating.rawValue)) }
    }
    
    //MARK: Clear all data
    func clearAllAppData() {
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        synchronize()
    }
}
