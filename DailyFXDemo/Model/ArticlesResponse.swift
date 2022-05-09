//
//  DailyFxArticles.swift
//  DailyFXDemo
//
//  Created by Nitesh Patel on 06/05/2022.
//

import Foundation

// MARK: - DailyFxArticles
struct ArticlesResponse: Codable {
    let breakingNews: String?
    let topNews: [Article]
    let dailyBriefings: DailyBriefings
    let technicalAnalysis, specialReport: [Article]
}

// MARK: - DailyBriefings
struct DailyBriefings: Codable {
    let eu, asia, us: [Article]
}
