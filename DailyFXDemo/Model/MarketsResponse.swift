//
//  MarketsResponse.swift
//  DailyFXDemo
//
//  Created by Nitesh Patel on 06/05/2022.
//

import Foundation

// MARK: - MarketsResponse
struct MarketsResponse: Codable {
    let currencies, commodities, indices: [Market]?
}
