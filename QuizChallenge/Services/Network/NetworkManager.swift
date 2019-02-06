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

typealias APIParameters = [String : Any]

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
    func getUser(with credentials: APIParameters, completion: @escaping (Result<User>) -> Void) {
        getRequest(type: User.self, parameters: credentials) { completion($0) }
    }
    
    func getQuestions(with credentials: APIParameters, completion: @escaping (Result<Question>) -> Void) {
        getRequest(type: Question.self, parameters: credentials) { completion($0) }
    }
    
    // ... get / create other object
    
    func cancelAllSessions() {
        Alamofire.SessionManager.default.session.getAllTasks { tasks in
            tasks.forEach({ $0.cancel() })
        }
    }
    
    // MARK: - Private request logic
    private func getRequest <T: Object> (type: T.Type, parameters: APIParameters? = nil, completion: @escaping (Result<T>) -> Void) where T:Mappable, T:Endpoint {
        
        let parameterss: [String: Any] = [
            "type" : "text",
            "category" : "cars"
        ]
        
        Alamofire.request(type.url(), method: .get, parameters: parameterss, encoding: JSONEncoding.prettyPrinted, headers: nil).responseJSON { response in
            switch response.result
            {
            case .success(let json):
                print(json)
                let code = response as? HTTPURLResponse
            case .failure(let error as NSError):
                completion(.error(error.description, error.code))
            }
        }
        
//        session.request(type.url(), parameters: parameters, encoding: JSONEncoding.default).responseObject { (response: DataResponse<T>) in
//
//            switch response.result {
//            case .success(let item):
//                do {
//                    try RealmManager.shared.storeObject(item)
//                    completion(.success(item))
//                } catch let error as NSError {
//                    completion(.error(error.description, error.code))
//                }
//
//            case .failure(let error as NSError):
//                completion(.error(error.description, error.code))
//            }
//        }
    }
    
    private func postRequest(parameters: APIParameters, completion: @escaping (Result<Any>) -> Void) {
        
        session.request(URL(string: "www")!, method: .post, parameters: parameters).responseJSON { response in
            // Waiting for server logic
        }
    }
    
    // ... get .. post
}
