//
//  Response.swift
//  QuizChallenge
//
//  Created by A.Makarov on 15/03/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import Foundation

enum ResponseState: Error {
    case success
    case networkError
    case badRequest
}

public enum ResponseStatusCode: Error {
    
    case ok
    case timeout
    case success(statusCode: Int)
    case badRequest
    case unAuthorized
    case forbidden
    case notFound
    case conflict
    case apiError(statusCode: Int)
    case serverError(statusCode: Int)
    case other(statusCode: Int)
    case badMappable
    
    public init(_ statusCode: Int) {
        switch statusCode {
        case 200:
            self = .ok
        case 201 ... 226:
            self = .success(statusCode: statusCode)
        case 400:
            self = .badRequest
        case 401:
            self = .unAuthorized
        case 403:
            self = .forbidden
        case 404:
            self = .notFound
        case 409:
            self = .conflict
        case 400 ... 499:
            self = .apiError(statusCode: statusCode)
        case 500 ... 527:
            self = .serverError(statusCode: statusCode)
        case -1001:
            self = .timeout
        default:
            self = .other(statusCode: statusCode)
        }
    }
}

extension ResponseStatusCode: CustomStringConvertible {
    
    public var description: String {
        return fullDescription
    }
    
    private var textDescription: String {
        
        switch self {
        case .timeout:
            return "Request timeout"
        case .ok:
            return "200 OK"
        case .success(let statusCode):
            return "\(statusCode) - Success request"
        case .badRequest:
            return "400 - Bad request. The entered values are incorrect"
        case .unAuthorized:
            return "401 - Unauthorized"
        case .forbidden:
            return "403 - Forbidden. Request is valid, but the server is refusing action"
        case .notFound:
            return "404 - Not Found"
        case .conflict:
            return "409 - Conflict"
        case .apiError(let statusCode):
            return "\(statusCode) - Client errors. Bad request"
        case .serverError(let statusCode):
            return "\(statusCode) - Server errors"
        case .badMappable:
            return "Map object error"
        case .other(let statusCode):
            return "\(statusCode) - Unknown error"
        }
    }
    
    private var emojiDescription: String {
        switch self {
        case .ok, .success:
            return "✅"
        case .unAuthorized, .forbidden:
            return "🔑"
        case .badRequest, .notFound, .conflict, .apiError:
            return "❌"
        default:
            return "🙈"
        }
    }
    
    private var fullDescription: String {
        return "\(textDescription) \(emojiDescription)"
    }
}
