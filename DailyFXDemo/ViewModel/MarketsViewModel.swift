//
//  MarketsViewModel.swift
//  DailyFXDemo
//
//  Created by Nitesh Patel on 07/05/2022.
//

import Foundation
import Combine

enum MarketType: String, CaseIterable {
    case All
    case Commodities
    case Currencies
    case Indices
}

class MarketsViewModel: ObservableObject {
    
    private let service: DailyFxService
    private(set) var marketsResponse: MarketsResponse?

    @Published private(set) var state: ResultState = .loading

    private var cancellable = Set<AnyCancellable>()

    init(service: DailyFxService) {
        self.service = service
        self.getMarkets()
    }
    
    func getMarkets() {
        self.state = .loading
        let cancellable = self.service
            .requestMarkets(from: .getMarkets)
            .sink { res in
                switch res {
                case .failure(let error):
                    self.state = .failed(error: error)
                case .finished:
                    self.state = .success
                }
            } receiveValue: { res in
                self.marketsResponse = res
            }
        
        self.cancellable.insert(cancellable)
    }
    
    func sectionItems() -> [MarketsSections]  {
        guard let marketsResponse = marketsResponse else {
            return []
        }
        var dashboardData: [MarketsSections]
        dashboardData = [MarketsSections(header: MarketType.Commodities.rawValue, rows: marketsResponse.commodities ?? []),
                         MarketsSections(header: MarketType.Currencies.rawValue, rows: marketsResponse.currencies ?? []),
                         MarketsSections(header: MarketType.Indices.rawValue, rows: marketsResponse.indices ?? [])]
        return dashboardData
    }
    
    func sectionItems(marketType: MarketType) -> [MarketsSections]  {
        guard let marketsResponse = marketsResponse else {
            return []
        }
        var dashboardData: [MarketsSections] = []
        switch marketType {
        case .Commodities:
            dashboardData = [MarketsSections(header: MarketType.Commodities.rawValue, rows: marketsResponse.commodities ?? [])]
        case .Currencies:
            dashboardData = [MarketsSections(header: MarketType.Currencies.rawValue, rows: marketsResponse.currencies ?? [])]
        case .Indices:
            dashboardData = [MarketsSections(header: MarketType.Indices.rawValue, rows: marketsResponse.indices ?? [])]
        case .All:
            dashboardData = sectionItems()
        }
        return dashboardData
    }
    
}

struct MarketsSections: Hashable {
    static func == (lhs: MarketsSections, rhs: MarketsSections) -> Bool {
        lhs.header == rhs.header && lhs.rows == rhs.rows
    }
    let id = UUID()
    let header: String
    let rows: [Market]
}
