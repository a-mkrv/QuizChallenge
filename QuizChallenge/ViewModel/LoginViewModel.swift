//
//  LoginViewModel.swift
//  QuizChallenge
//
//  Created by Anton Makarov on 12/02/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum LoginResponse {
    case success
    case noInterner
    case failCredentials
    case none
}

class LoginViewModel {
    
    // BehaviorRelay
    
    let username: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    let password: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    
    let disposeBag = DisposeBag()

    // MARK: - Public methods
    
    func isUserNameValid() -> Observable<Bool> {
        
        return username.asObservable().map { (username) in
            guard let username = username else { return false }
            let loginPredicate = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._]{5,}")
            return loginPredicate.evaluate(with: username) || username.count == 0
        }
    }
    
    func isPasswordValid() -> Observable<Bool> {
        
        return password.asObservable().map { (password) in
            guard let password = password else { return false }
            let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._]{5,}")
            return passwordPredicate.evaluate(with: password) || password.count == 0
        }
    }
    
    func isUserNameAndPasswordValid() -> Observable<Bool> {
        
        return Observable.combineLatest(isUserNameValid(), isPasswordValid()) { $0 && $1 }
            .distinctUntilChanged()
    }
    
    func serverNativeLogin() -> Observable<LoginResponse> {
      
        return Observable.create{ observer in
            
            guard CommonHelper.checkNetworkStatus() else {
                observer.onNext(.noInterner)
                return Disposables.create()
            }
            
            let credentials: APIParameters = ["username": self.username.value!,
                                              "password": self.password.value!]
            
            print("next")
            NetworkManager.shared.doLogin(with: credentials)
                .subscribe(onNext: { _ in
                    observer.onNext(.success)
                }, onError: { _ in
                    observer.onNext(.failCredentials)
                }).disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
}
