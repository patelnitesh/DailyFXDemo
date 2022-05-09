//
//  DailyFxService.swift
//  DailyFXDemo
//
//  Created by Nitesh Patel on 06/05/2022.
//

import Foundation
import Combine

protocol DailyFxService {
    func requestArticles(from endpoint: APIEndPoint) -> AnyPublisher<ArticlesResponse, APIError>
    func requestMarkets(from endpoint: APIEndPoint) -> AnyPublisher<MarketsResponse, APIError>
}

struct DailyFxServiceImpl: DailyFxService {
    
    func requestArticles(from endpoint: APIEndPoint) -> AnyPublisher<ArticlesResponse, APIError> {
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        
        return URLSession.shared
            .dataTaskPublisher(for: endpoint.urlRequest)
            .receive(on: DispatchQueue.main)
            .mapError { _ in .unknown }
            .flatMap { data, response -> AnyPublisher<ArticlesResponse, APIError> in
                guard let response = response as? HTTPURLResponse else {
                    return Fail(error: .unknown)
                        .eraseToAnyPublisher()
                }
                
                if (200...299).contains(response.statusCode) {
                    return Just(data)
                        .decode(type: ArticlesResponse.self, decoder: jsonDecoder)
                        .mapError {_ in .decodingError}
                        .eraseToAnyPublisher()
                } else {
                    return Fail(error: .errorCode(response.statusCode))
                        .eraseToAnyPublisher()
                }
            }.eraseToAnyPublisher()
    }
    
    //TODO: Merge 👆🏻 and 👇🏻 function together
    func requestMarkets(from endpoint: APIEndPoint) -> AnyPublisher<MarketsResponse, APIError> {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        
        return URLSession.shared
            .dataTaskPublisher(for: endpoint.urlRequest)
            .receive(on: DispatchQueue.main)
            .mapError { _ in .unknown }
            .flatMap { data, response -> AnyPublisher<MarketsResponse, APIError> in
                
                guard let response = response as? HTTPURLResponse else {
                    return Fail(error: .unknown)
                        .eraseToAnyPublisher()
                }
                
                if (200...299).contains(response.statusCode) {
                    return Just(data)
                        .decode(type: MarketsResponse.self, decoder: jsonDecoder)
                        .mapError {_ in .decodingError}
                        .eraseToAnyPublisher()
                } else {
                    return Fail(error: .errorCode(response.statusCode))
                        .eraseToAnyPublisher()
                }
            }.eraseToAnyPublisher()
    }
}
