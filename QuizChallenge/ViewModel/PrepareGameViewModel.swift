//
//  PrepareGameViewModel.swift
//  QuizChallenge
//
//  Created by A.Makarov on 19/03/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class PrepareGameViewModel {
    
    let disposeBag = DisposeBag()
    //let createGameDidTapObservable: Observable<Bool>
    
    func searchUserBy(name: String) -> Observable<Opponent> {
        return Observable.create{ observer in
            
            let user: APIParameters = ["opponent": name]
            NetworkManager.shared.searchOpponent(with: user)
                .subscribe(onNext: { opponent in
                    observer.onNext(opponent)
                }, onError: { error in
                    observer.onError(error)
                }).disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    func createGameWithRandomUser(category: String) -> Observable<ResponseState> {
        
        let params = ["type": "text",  "category": category]
        
        return Observable.create{ observer in
            
        NetworkManager.shared.createNewGames(with: params)
            .subscribe(onNext: { _ in
                observer.onNext(.success)
                observer.onCompleted()
            }, onError: { error in
                observer.onError(error)
                CommonHelper.alert.showAlertView(title: "Error", subTitle: "Something went wrong", buttonText: "Search Again", type: .error)
            }).disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
}
