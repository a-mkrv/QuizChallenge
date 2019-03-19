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
    case error(Error?)
}

// MARK: - NetworkManager

class NetworkManager {
    
    // MARK: Init Singleton
    
    static let shared = NetworkManager()
    private var session = Alamofire.SessionManager(configuration: .default)
    private let baseUrl = "http://138.68.102.85:8080"
    private let tokenHeader = ["Authorization": "Bearer " + UserManager.shared.userToken]
    
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 20
        session = Alamofire.SessionManager(configuration: configuration)
    }
    
    // MARK: - Open API Methods (With Mappable)

    func register(with userInfo: APIParameters) -> Observable<Registration> {
        return doRequest(type: Registration.self, parameters: userInfo, method: .post)
    }
    
    func doLogin(with credentials: APIParameters) -> Observable<Login> {
        return doRequest(type: Login.self, parameters: credentials, method: .post)
    }
    
    func getGamesHistory() -> Observable<Session> {
        return doRequest(type: Session.self, parameters: nil, method: .get)
    }
    
    func searchOpponent(with userInfo: APIParameters) -> Observable<Opponent> {
        return doRequest(type: Opponent.self, parameters: userInfo, method: .get)
    }
    
    func getQuestions(with parameters: APIParameters) -> Observable<Question> {
        return doRequest(type: Question.self, parameters: parameters, method: .get)
    }
    
    // MARK: - Requests without Mappable Model
    
    func createQuestion(with questionInfo: APIParameters) -> Observable<ResponseState> {
        return doRequestWithoutModel(url: "/questions", parameters: questionInfo, method: .post)
    }
    
    func createNewGames(with userInfo: APIParameters) -> Observable<ResponseState> {
        return doRequestWithoutModel(url: "/games/search_game", parameters: userInfo, method: .post)
    }
    
    // MARK: - Private request method
    
    private func doRequestWithoutModel(url: String, parameters: APIParameters? = nil, method: HTTPMethod = .get) -> Observable<ResponseState> {
        
        guard CommonHelper.checkNetworkStatus() else {
            return Observable.create { observer in
                observer.onNext(.networkError)
                return Disposables.create()
            }
        }
        
        return Observable.create { observer in
            
            let request = Alamofire.request(self.baseUrl + url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: self.tokenHeader)
                .validate(statusCode: 200..<300)
                .responseJSON { response in
                    let statusCode = ResponseStatusCode(response.response?.statusCode ??  response.result.error?._code ?? 0)
                    
                    switch response.result {
                    case .success(_):
                        observer.onNext(.success)
                    case .failure(let error):
                        if error._code == NSURLErrorTimedOut {
                            observer.onError(ResponseStatusCode.timeout)
                        } else {
                            observer.onError(statusCode)
                        }
                    }
                    observer.onCompleted()
                    Logger.debug(msg: statusCode, type: .NETWORK)
            }
            
            return Disposables.create {
                request.cancel()
            }
            }
            .observeOn(MainScheduler.instance)
            .share(replay: 1, scope: .whileConnected)
    }
    
    private func doRequest <T: Object> (type: T.Type, parameters: APIParameters?, method: HTTPMethod) -> Observable<T> where T:Mappable, T:Endpoint {
        
        return Observable.create { observer in
            
            let request = Alamofire.request(self.baseUrl + type.url(), method: method, parameters: parameters, encoding: JSONEncoding.default)
                .validate(statusCode: 200..<300)
                .responseJSON { response in
                    let statusCode = ResponseStatusCode(response.response?.statusCode ??  response.result.error?._code ?? 0)
                    
                    switch response.result {
                    case .success(let value):
                        if let response = Mapper<T>().map(JSONObject: value) {
                            observer.onNext(response)
                        } else {
                            observer.onError(ResponseStatusCode.badMappable)
                        }
                    case .failure(let error):
                        observer.onError(statusCode)
                    }
                    observer.onCompleted()
                    Logger.debug(msg: statusCode, type: .NETWORK)
            }
            
            return Disposables.create {
                request.cancel()
            }
            }
            .observeOn(MainScheduler.instance)
            .share(replay: 1, scope: .whileConnected)
    }
    
    // MARK: - Other methods
    
    func cancelAllSessions() {
        Alamofire.SessionManager.default.session.getAllTasks { tasks in
            tasks.forEach({ $0.cancel() })
        }
    }
}
