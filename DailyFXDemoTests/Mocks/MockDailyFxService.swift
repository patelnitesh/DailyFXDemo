//
//  MockDailyFxService.swift
//  DailyFXDemoTests
//
//  Created by Nitesh Patel on 08/05/2022.
//

import Combine
@testable import DailyFXDemo

class MockDailyFxService: DailyFxService {
    var getArticlesCalled = false
    var fetchArticles: AnyPublisher<ArticlesResponse, APIError>!
    
    func requestArticles(from endpoint: APIEndPoint) -> AnyPublisher<ArticlesResponse, APIError> {
        getArticlesCalled = true
        return fetchArticles
    }

    var getMarketsCalled = false
    var fetchMarkets: AnyPublisher<MarketsResponse, APIError>!
    func requestMarkets(from endpoint: APIEndPoint) -> AnyPublisher<MarketsResponse, APIError> {
        getMarketsCalled = true
        return fetchMarkets
    }
}

