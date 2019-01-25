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
    
    // MARK: Init Singleton
    
    static let shared = NetworkManager()
    private var session = Alamofire.SessionManager(configuration: .default)
    private let baseUrl = "https://quizbackend.com"
    
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 20
        session = Alamofire.SessionManager(configuration: configuration)
    }
    
    // MARK: - Open Methods
    func getUser(completion: @escaping (Result<Bool>) -> Void) {
        getRequest(type: User.self, completion: completion)
    }
    
    // ... get / create other object
    
    // MARK: - Private request logic
    private func getRequest <T: Object> (type: T.Type, completion: @escaping (Result<Bool>) -> Void) -> Void where T:Mappable, T:Endpoint {
        
        session.request(type.url()).responseObject { (response: DataResponse<T>) in
            
            switch response.result {
            case .success(let item):
                do {
                    try RealmManager.shared.storeObject(item)
                    completion(.success(true))
                } catch let error as NSError {
                    completion(.error(error.description, error.code))
                }
                
            case .failure(let error as NSError):
                completion(.error(error.description, error.code))
            }
        }
    }
    
    // ... post
}
