//
//  ValidationViewModel.swift
//  QuizChallenge
//
//  Created by Anton Makarov on 19/02/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol ValidationViewModel {
    
    // Observables
    var data: BehaviorRelay<String> { get set }
    
    // Validation
    func validateCredentials() -> Observable<Bool>
}

// MARK: - Username Validate

class UsernameViewModel : ValidationViewModel {
    
    var data = BehaviorRelay(value: "")
    
    func validateCredentials() -> Observable<Bool> {
        return data.asObservable().map({ (username) -> Bool in
            let regex = "[A-Z0-9a-z._]{5,}"
            let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
            return passwordPredicate.evaluate(with: username) || username.isEmpty
            // MARK: isEmpty needs for blue line, if textfield is empty
        })
    }
}

// MARK: - Email Validate

class EmailViewModel : ValidationViewModel {
    
    var data = BehaviorRelay(value: "")

    func validateCredentials() -> Observable<Bool> {
         return data.asObservable().map({ (email) -> Bool in
            let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
            let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
            return passwordPredicate.evaluate(with: email) || email.isEmpty
        })
    }
}

// MARK: - Password Validate

class PasswordViewModel : ValidationViewModel {
    
    var data = BehaviorRelay(value: "")

    func validateCredentials() -> Observable<Bool> {
        return data.asObservable().map({ (password) -> Bool in
            let regex = "[A-Z0-9a-z._]{5,}"
            let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
            return passwordPredicate.evaluate(with: password) || password.isEmpty
        })
    }
}
