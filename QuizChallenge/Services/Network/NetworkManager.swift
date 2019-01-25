//
//  NetworkManager.swift
//  QuizChallenge
//
//  Created by Anton Makarov on 22/01/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import AlamofireObjectMapper
import RealmSwift

enum Result<Value> {
    case success(Value)
    case error(String, Int)
}

class NetworkManager {
    
    static let shared = NetworkManager()
    private var session = Alamofire.SessionManager(configuration: .default)
    private let baseUrl = "https://quizbackend.com"

    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 20
        session = Alamofire.SessionManager(configuration: configuration)
    }

    func getUserProfile <T: Object> (type: T.Type, completion: @escaping (Result<Bool>) -> Void) -> Void where T:Mappable, T:Endpoint {
        
        session.request(type.url()).responseArray { (response: DataResponse<[T]>) in
            
            switch response.result {
            case .success(let items):
                //TODO: Rewrite to separate storage class
                    do {
                        let realm = try Realm()
                        try realm.write {
                            for item in items {
                                realm.add(item, update: true)
                            }
                        }
                        completion(.success(true))
                    } catch let error as NSError {
                        completion(.error(error.description, error.code))
                    }
            case .failure(let error as NSError):
                completion(.error(error.description, error.code))
            }
        }
    }
    
}
