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
    private let baseUrl = "http://138.68.102.85:8080"
    
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 20
        session = Alamofire.SessionManager(configuration: configuration)
    }
    
    // MARK: - Open API Methods
    
    func register(with userInfo: APIParameters) -> Observable<Registration> {
        return doRequest(type: Registration.self, parameters: userInfo, method: .post)
            .observeOn(MainScheduler.instance)
            .share(replay: 1, scope: .whileConnected)
    }
    
    func doLogin(with credentials: APIParameters) -> Observable<Login> {
        return doRequest(type: Login.self, parameters: credentials, method: .post)
            .observeOn(MainScheduler.instance)
            .share(replay: 1, scope: .whileConnected)
    }
    
    func getTestModel() -> Observable<TestModel> {
        return doRequest(type: TestModel.self, parameters: nil, method: .get)
            .observeOn(MainScheduler.instance)
            .share(replay: 1, scope: .whileConnected)
    }
    
    func createQuestion(with questionInfo: APIParameters) -> Observable<Bool> {
        return doRequestWithoutModel(url: "/questions", parameters: questionInfo, method: .post)
            .observeOn(MainScheduler.instance)
            .share(replay: 1, scope: .whileConnected)
    }

    
    func getActiveGames(with userInfo: APIParameters) -> Observable<Bool> {
        return doRequestWithoutModel(url: "/games/search_game", parameters: userInfo, method: .get)
            .observeOn(MainScheduler.instance)
            .share(replay: 1, scope: .whileConnected)
    }
    
    // MARK: Private request method
    
    private func doRequestWithoutModel(url: String, parameters: APIParameters?, method: HTTPMethod) -> Observable<Bool> {
        
        return Observable.create { observer in
            let header = ["Authorization": "Bearer " + UserManager.shared.userToken]
            
            let request = Alamofire.request(self.baseUrl + url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: header)
                .responseJSON { response in
                    
                    switch response.result {
                    case .success(_):
                        observer.onNext(true)
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
    
    private func doRequest <T: Object> (type: T.Type, parameters: APIParameters?, method: HTTPMethod) -> Observable<T> where T:Mappable, T:Endpoint {
        
        return Observable.create { observer in
            
            let request = Alamofire.request(self.baseUrl + type.url(), method: method, parameters: parameters, encoding: JSONEncoding.default)
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
