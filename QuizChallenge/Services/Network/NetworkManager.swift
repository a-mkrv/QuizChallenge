//
//  NetworkManager.swift
//  QuizChallenge
//
//  Created by Anton Makarov on 22/01/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire
import ObjectMapper
import AlamofireObjectMapper
import RealmSwift

// MARK: - Network settings

typealias APIParameters = [String : Any]

enum Result<Value> {
    case success(Value)
    case error(String, Int)
}

enum ApiError: Error {
    case forbidden              // Code 403
    case notFound               // Code 404
    case conflict               // Code 409
    case internalServerError    // Code 500
}

// MARK: - NetworkManager

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
    
    // MARK: - Open API Methods
    
    func doLogin(with credentials: APIParameters) -> Observable<User> {
        return request(type: User.self, parameters: credentials)
            .observeOn(MainScheduler.instance)
            .share(replay: 1, scope: .whileConnected)
    }
    
    func getTestModel() -> Observable<TestModel> {
        return request(type: TestModel.self, parameters: nil)
            .observeOn(MainScheduler.instance)
            .share(replay: 1, scope: .whileConnected)
    }
    
    // MARK: Private request method
    
    private func request <T: Object> (type: T.Type, parameters: APIParameters?) -> Observable<T> where T:Mappable, T:Endpoint {
        
        return Observable.create { observer in
            
            let request = Alamofire.request(type.url(), method: .get, parameters: parameters)
                .validate()
                .responseJSON { response in
                    
                    switch response.result {
                    case .success(let value):
                        if let response = Mapper<T>().map(JSONObject: value) {
                            observer.onNext(response)
                        } else {
                            observer.onError(ApiError.notFound)
                        }
                    case .failure(let error):
                        observer.onError(error)
                    }
                    observer.onCompleted()
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    // MARK: Other methods
    
    func cancelAllSessions() {
        Alamofire.SessionManager.default.session.getAllTasks { tasks in
            tasks.forEach({ $0.cancel() })
        }
    }
}
