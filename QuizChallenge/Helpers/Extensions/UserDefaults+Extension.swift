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
    
    private func createKey(_ key: String) -> String {
        return (appName ?? "QuizChallenge") + "-" + key
    }
    
    //FIXME: Refactoring in separate one object (UserManager)
    var isLoggedIn: Bool? {
        set {
            set(newValue, forKey: createKey(#function))
            synchronize()
        }
        get { return bool(forKey: createKey(#function)) }
    }
    
    var userToken: String? {
        set {
            set(newValue, forKey: createKey(#function))
            synchronize()
        }
        get { return string(forKey: createKey(#function)) }
    }
    
    var userName: String? {
        set {
            set(newValue, forKey: createKey(#function))
            synchronize()
        }
        get { return string(forKey: createKey(#function)) }
    }
    
    var isShowWelcomeScreen: Bool {
        set {
            set(newValue, forKey: createKey(#function))
            synchronize()
        }
        get { return bool(forKey: createKey(#function)) }
    }
    
    //MARK: Clear all data
    func clearAllAppData() {
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        synchronize()
    }
}
