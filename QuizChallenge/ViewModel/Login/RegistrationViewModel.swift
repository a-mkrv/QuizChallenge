//
//  RegistrationViewModel.swift
//  QuizChallenge
//
//  Created by Anton Makarov on 19/02/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class RegistrationViewModel {
    
    let usernameViewModel = UsernameViewModel()
    let emailViewModel = EmailViewModel()
    let passwordViewModel = PasswordViewModel()
    
    let disposeBag = DisposeBag()
    
    // MARK: - Public methods

    func isValidAllData() -> Observable<Bool> {
        
        return Observable.combineLatest(usernameViewModel.validateCredentials(), emailViewModel.validateCredentials(), passwordViewModel.validateCredentials(), usernameViewModel.data, emailViewModel.data, passwordViewModel.data) { $0 && $1 && $2 && $3.count > 0 && $4.count > 0 && $5.count > 0 }
            .distinctUntilChanged()
    }
    
    func registration() -> Observable<LoginResponse> {
        
        return Observable.create{ observer in
            
            guard CommonHelper.checkNetworkStatus() else {
                observer.onNext(.noInterner)
                return Disposables.create()
            }
            
            let userData: APIParameters = ["username": self.usernameViewModel.data.value,
                                           "password": self.passwordViewModel.data.value,
                                           "email": self.emailViewModel.data.value]
            
            NetworkManager.shared.register(with: userData)
                .subscribe(onNext: { _ in
                    observer.onNext(.success)
                }, onError: { _ in
                    observer.onNext(.failCredentials)
                }).disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
}
