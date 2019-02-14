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
            return loginPredicate.evaluate(with: username)
        }
    }
    
    func isPasswordValid() -> Observable<Bool> {
        
        return password.asObservable().map { (password) in
            guard let password = password else { return false }
            let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._]{5,}")
            return passwordPredicate.evaluate(with: password)
        }
    }
    
    func isUserNameAndPasswordValid() -> Observable<Bool> {
        
        return Observable.combineLatest(isUserNameValid(), isPasswordValid()) { $0 && $1 }
            .distinctUntilChanged()
    }
    
    func serverNativeLogin() -> Observable<LoginResponse> {
        return Observable.create{ observer in
            if !CommonHelper.checkNetworkStatus() {
                observer.onNext(LoginResponse.noInterner)
            }
            
            NetworkManager.shared.getTestModel()
                .subscribe(onNext: { (test) in
                    observer.onNext(LoginResponse.success)
                }, onError: { (error) in
                    observer.onNext(LoginResponse.failCredentials)
                }).disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
}
