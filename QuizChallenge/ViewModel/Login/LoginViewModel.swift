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
    
    let usernameViewModel = UsernameViewModel()
    let passwordViewModel = PasswordViewModel()
    
    let disposeBag = DisposeBag()

    // MARK: - Public methods
    
    func isUserNameAndPasswordValid() -> Observable<Bool> {
        
        return Observable.combineLatest(usernameViewModel.validateCredentials(), passwordViewModel.validateCredentials(), usernameViewModel.data, passwordViewModel.data) { $0 && $1 && $2.count > 0 && $3.count > 0 }
            .distinctUntilChanged()
    }
    
    func serverNativeLogin() -> Observable<LoginResponse> {
      
        return Observable.create{ observer in
            
            guard CommonHelper.checkNetworkStatus() else {
                observer.onNext(.noInterner)
                return Disposables.create()
            }
            
            let credentials: APIParameters = ["username": self.usernameViewModel.data.value,
                                              "password": self.passwordViewModel.data.value]
            
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