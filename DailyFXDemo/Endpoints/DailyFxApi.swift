//
//  DailyFxApi.swift
//  DailyFXDemo
//
//  Created by Nitesh Patel on 06/05/2022.
//

import Foundation

protocol APIBuilder {
    var urlRequest: URLRequest { get }
    var baseUrl: URL { get }
    var path: String { get }
}


enum APIEndPoint {
    case getArticles
    case getMarkets
}

extension APIEndPoint: APIBuilder {

    var baseUrl: URL {
            return URL(string: "https://content.dailyfx.com/api/v1")!
    }
    
    var path: String {
        switch self {
        case .getArticles:
            return "/dashboard"
        case .getMarkets:
            return "/markets"
        }
    }
    
    var urlRequest: URLRequest {
        switch self {
        case .getArticles:
            return URLRequest(url: self.baseUrl.appendingPathComponent(self.path))
        case .getMarkets:
            return URLRequest(url: self.baseUrl.appendingPathComponent(self.path))
        }
    }
}

enum APIError: Error {
    case decodingError
    case errorCode(Int)
    case unknown
}

extension APIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .decodingError:
            return "Failed to decode the error from the service"
        case .errorCode(let code):
            return "\(code) - Something went wrong"
        case .unknown:
            return "The error is unknown"
        }
    }
}
