//
//  AuthFacadeController.swift
//  QuizChallenge
//
//  Created by A.Makarov on 15/03/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

typealias authComplitionData = (Result<AuthData>) -> ()

protocol Authorizable {
    func authorize(complition: @escaping authComplitionData)
}

enum SocialNetwork {
    case Facebook
    case Vkontakte
    case Google
}

struct AuthData {
    var name = ""
    var email = ""
    var age = 0
    var location = ""
    var token = ""
    
    init(name: String = "", email: String = "", age: Int = 0, location: String = "", token: String) {
        self.name = name
        self.email = email
        self.age = age
        self.location = location
        self.token = token
    }
}

// Facade Login Controller
class AuthFacadeController: NSObject {
    
    static func doLogin(type: SocialNetwork) -> Observable<ResponseState> {
        let auth = setupAuthType(type)
        
        return Observable.create{observer in
            auth.authorize(complition: { result in
                switch result {
                case .error(let error):
                    observer.onNext(.invalidStatusCode(code: error as! ResponseCode))
                case .success:
                    observer.onNext(.success)
                }
                observer.onCompleted()
            })
            
            return Disposables.create()
        }
    }
    
    
    static func setupAuthType(_ type: SocialNetwork) -> Authorizable {
        
        switch type {
        case .Facebook:
            return FBAuth()
        case .Vkontakte:
            return VKAuth()
        case .Google:
            return GoogleAuth()
        }
    }
    
}

