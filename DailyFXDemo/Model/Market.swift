//
//  Market.swift
//  DailyFXDemo
//
//  Created by Nitesh Patel on 09/05/2022.
//

import Foundation

// MARK: - Market
struct Market: Codable, Identifiable, Hashable {
    let id = UUID()
    let displayName, marketID, epic: String?
    let rateDetailURL: String?
    let topMarket: Bool?
    let unscalingFactor, unscaledDecimals: Int?
    let calendarMapping: [CalendarMapping]?

    enum CodingKeys: String, CodingKey {
        case displayName
        case marketID = "marketId"
        case epic, rateDetailURL, topMarket, unscalingFactor, unscaledDecimals, calendarMapping
    }
}

enum CalendarMapping: String, Codable {
    case aud = "AUD"
    case cad = "CAD"
    case chf = "CHF"
    case cny = "CNY"
    case eur = "EUR"
    case gbp = "GBP"
    case jpy = "JPY"
    case mxn = "MXN"
    case nzd = "NZD"
    case usd = "USD"
}
