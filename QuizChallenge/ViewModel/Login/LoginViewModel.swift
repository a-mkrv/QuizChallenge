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

class LoginViewModel {
    
    let usernameViewModel = UsernameViewModel()
    let passwordViewModel = PasswordViewModel()
    
    let disposeBag = DisposeBag()

    // MARK: - Public methods
    
    func isUserNameAndPasswordValid() -> Observable<Bool> {
        
        return Observable.combineLatest(usernameViewModel.validateCredentials(), passwordViewModel.validateCredentials(), usernameViewModel.data, passwordViewModel.data) { $0 && $1 && $2.count > 0 && $3.count > 0 }
            .distinctUntilChanged()
    }
    
    func socialNetworkAuth(with socialNetworkType: SocialNetwork) -> Observable<ResponseState> {
        return AuthFacadeController.doLogin(type: socialNetworkType)
    }
    
    func serverNativeLogin() -> Observable<ResponseState> {
      
        return Observable.create{ observer in
            
            guard CommonHelper.checkNetworkStatus() else {
                observer.onNext(.networkError)
                return Disposables.create()
            }
            
            let credentials: APIParameters = ["username": self.usernameViewModel.data.value,
                                              "password": self.passwordViewModel.data.value]
            
            NetworkManager.shared.doLogin(with: credentials)
                .subscribe(onNext: { loginData in
                    try? RealmManager.shared.storeObject(loginData)
                    UserManager.shared.userToken = loginData.token
                    UserManager.shared.userName = loginData.user?.username ?? "Unknown"
                    observer.onNext(.success)
                }, onError: { error in
                    Logger.error(msg: "Login Error: \(error)")
                    observer.onNext(.badRequest)
                }).disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
}
